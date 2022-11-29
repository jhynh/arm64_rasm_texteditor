//need to pass the head ptr, tail ptr, and reasign them as needed
    .data

    .global deleteInfo
    .text
deleteInfo:
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
//choose a node, delete it. if it's head, change tail. if it's tail, change tail. if it's in the middle, delete and relink


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
