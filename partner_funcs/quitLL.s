// clear linked list

    .global quitLL
    .text

quitLL:
    ADD     X30,X30,#4

    STR     LR,[SP,#-16]!       // push to stack
    LDR     X0,=headPtr         // point X0 to headPtr
    LDR     X0,[X0]             // point X0 to X0 address

clearLoop:
    CMP     X0,#0               // compare X0 to null
    B.EQ    exit                // if equal goto exit

    LDR     X1,[X0]             // point X1 to X0 address
    LDR     X2,[X0,#8]          // point X2 to X0 address
    STP     X1,X2,[SP,#-16]!    // push to stack
    BL      free                // free node

    LDP     X0,X1,[SP],#16      // pop to stack
    STR     X1,[SP,#-16]!       // push to stack
    BL      free                // free string

    LDR     X0,[SP],#16         // pop from stack
    B       clearLoop           // loop

exit:
    MOV     X1,#0               // move null to X1
    LDR     X0,=headPtr         // point X0 to headPtr
    STR     X1,[X0]             // store X0 address to X1
    LDR     X0,=tailPtr         // point X0 to tailPtr
    STR     X1,[X0]             // store X0 address to X1
    LDR     X0,=iNodes          // point X0 to iNodes
    STR     X1,[X0]             // store X0 address to X1
    LDR     LR,[SP],#16         // pop from stack
    RET                         // return
    
    .end
