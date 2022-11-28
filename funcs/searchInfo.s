    .data
    szPrompt:       .asciz  "search for: "
    chLF:         .byte   10
    szSubArr:       .skip   21
    

    .global searchInfo
    .text
searchInfo:
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
    //ask the user for a string
    //traverse each node, load it, and call subarray
    MOV X19, X1
    MOV X20, X2
    LDR X0,=szPrompt
    BL putstring
    LDR X0,=szSubArr
    MOV X1, 21
    BL getstring
    LDR X19,[X19]
loop:
//now traverse your linked list, running substr with each
    LDR X1,=szSubArr
    LDR X2,[X19]             //deref ptr

    BL string_Substring     //BL

    //print, then this will run until end
    CMP X0, #1
    B.EQ printer
    B over
printer:
    LDR X0,[X19]
    BL putstring
over:
//go to next node
    //load current ptr X19
    //follow nxt ptr
    LDR X19,[X19, #8]
    CMP X19, #0
    B.EQ done

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

    