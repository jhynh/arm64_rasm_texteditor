//given a headPtr in X1, and tail in X2, prompt for index and find node containing it
.data
    szPrompt1:  .asciz "Enter a index to modify: "
    qdCur:      .quad 0
    qdNxt:      .quad 0
    szIndex:    .skip 21
    chLF:       .byte 10
.global findNode
.text
findNode:
    STR X19, [SP,#-16]!     //push
    STR X20, [SP,#-16]!     //push
    STR X21, [SP,#-16]!     //push
    STR X22, [SP,#-16]!     //push
    STR X23, [SP,#-16]!     //push
    STR X24, [SP,#-16]!     //push
    STR X25, [SP,#-16]!     //push
    STR X26, [SP,#-16]!     //push
    STR X27, [SP,#-16]!     //push
    STR X28, [SP,#-16]!     //push
    STR X29, [SP,#-16]!     //push
    STR X30, [SP,#-16]!     //push

    MOV X19, X1     //move head
    MOV X20, X2     //move tail

    LDR X0,=szPrompt1
    BL putstring

    LDR X0,=szIndex
    MOV X1, #8
    BL getstring
//mod the printContents func
//--------------------------------------------------------------------------------------------------------------
//traverse each node and get the strlength, when the total length = szIndex, return address
    LDR X0,=szIndex
    BL ascint64         //convert
    LDR X22,=szIndex
    STR X0,[X22]

    LDR X3,=qdCur
    MOV X0, X19         //move headptr
    STR X0,[X3]
    LDR X0,[X0]         //deref
    CMP X0, #0          //see contents
    B.EQ done           //exit
    LDR X0,[X0]         //unload
    BL strlength        //print
    SUB X0, X0, #1
    ADD X24, X24, X0    //count
    BL cmpr

    LDR X3,=qdCur
    MOV X0, X19         //back to head
    STR X0,[X3]
    LDR X0,[X0]
    LDR X0,[X0, #8]     //nxt ptr
    CMP X0, #0          //check null
    B.EQ done
    LDR X21,=qdNxt      //load var
    STR X0,[X21]        //store nxt ptr

loop:
//assume X1 and X2 contain head and tail ptr
    LDR X3,=qdCur
    LDR X0,=qdNxt
    STR X0,[X3]
    LDR X0,[X0]         //deref
    CMP X0, #0
    B.EQ done           //empty address for content
    LDR X0,[X0]
    BL strlength
    SUB X0, X0, #1
    ADD X24, X24, X0
    BL cmpr             //compare the total and target index

    LDR X0,[X21]
    LDR X0,[X0, #8]
    CMP X0, #0
    B.EQ done
    LDR X21,=qdNxt
    STR X0,[X21]
    B loop

done:
//--------------------------------------------------------------------------------------------------------------
    LDR X0,[X0]             //dereference local var
    LDR X0,[X0]             //dereference another weird encapsulation and return the node itself

    LDR X30,[SP], #16       //pop
    LDR X29,[SP], #16       //pop
    LDR X28,[SP], #16       //pop
    LDR X27,[SP], #16       //pop
    LDR X26,[SP], #16       //pop
    LDR X25,[SP], #16       //pop
    LDR X24,[SP], #16       //pop
    LDR X23,[SP], #16       //pop
    LDR X22,[SP], #16       //pop
    LDR X21,[SP], #16       //pop
    LDR X20,[SP], #16       //pop
    LDR X19,[SP], #16       //pop
    RET LR

cmpr:
//X28 contains the total count, see if the current count is above or at our targetted index
    LDR X22,=szIndex
    LDR X22,[X22]
    CMP X24, X22            //compare target to current count
    B.GE found             //if total count > than our target, we have it, return the address
    B loss
found:
//load the address of current node and exit
    LDR X0,=qdCur
    B done
loss:
    RET LR
