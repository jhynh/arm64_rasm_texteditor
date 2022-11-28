//printing out the linked list
    .data
    szStuff:        .asciz "\nprinting stuff\n"
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


//assume X1 and X2 contain head and tail ptr
    MOV X0, X1
    LDR X0,[X0]
    LDR X0,[X0]
    BL putstring

    MOV X0, X1
    LDR X0,[X0]
    LDR X0,[X0, #8]         //load nxt ptr
    LDR X0,[X0]             //deref
    BL putstring            //print
    MOV X0, X1
    LDR X0,[X0]
    LDR X0,[X0, #8]         //load next ptr
    LDR X0,[X0, #8]         //load next ptr
    LDR X0,[X0]
    BL putstring            //print
        MOV X0, X1
    LDR X0,[X0]
    LDR X0,[X0, #8]         //load next ptr
    LDR X0,[X0, #8]         //load next ptr
    LDR X0,[X0, #8]         //load next ptr
    LDR X0,[X0]
    BL putstring            //print

end:
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
