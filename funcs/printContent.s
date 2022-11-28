//printing out the linked list
    .data
    qdNxt:      .quad 0
    chLF:       .byte 10
    .global printContent
    .text
printContent:
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

    MOV X19, X1
    MOV X20, X2

    MOV X0, X19  //move headptr
    LDR X0,[X0] //deref
    CMP X0, #0  //see contents
    B.EQ done   //exit
    LDR X0,[X0] //unload
    BL putstring//print

    MOV X0, X19      //back to head
    LDR X0,[X0]
    LDR X0,[X0, #8] //nxt ptr
    CMP X0, #0  //check null
    B.EQ done
    LDR X21,=qdNxt  //load var
    STR X0,[X21]    //store nxt ptr

loop:
//assume X1 and X2 contain head and tail ptr
    LDR X0,=qdNxt
    LDR X0,[X0]             //deref
    CMP X0, #0
    B.EQ done               //empty address for content
    LDR X0,[X0]
    BL putstring    //print

    LDR X0,[X21]            //deref node ptr
    LDR X0,[X0, #8]
    CMP X0, #0
    B.EQ done
    LDR X21,=qdNxt
    STR X0,[X21]
    B loop

done:
    LDR X0,=chLF
    BL putch
    LDR X0,=chLF
    BL putch
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
