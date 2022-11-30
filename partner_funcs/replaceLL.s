// replace node in linked list
// X0 - index to replace
// X1 - replacement address

    .global replaceLL
    .text

replaceLL:
    ADD     X30,X30,#4

    STR     LR,[SP,#-16]!       // push to stack
    STP     X0,X1,[SP,#-16]!    // push to stack
    LDP     X0,X1,[SP],#16      // pop from stack
    MOV     X3,X0               // move X0 to X3
    MOV     X2,#0               // move 0 to X2
    LDR     X0,=headPtr         // point X0 to headPtr
    LDR     X0,[X0]             // point X0 address to X0

find:
    CMP     X0,#0               // compare X0 to null
    B.EQ    exit                // if equal goto exit

    CMP     X2,X3               // compare X2 to X3
    B.EQ    replace             // if equal goto replace

    ADD     X2,X2,#1            // increment X2
    ADD     X0,X0,#8            // increment X0
    LDR     X0,[X0]             // point X0 to X0 address
    B       find                // loop

replace:
    STP     X0,X1,[SP,#-16]!    // push to stack
    LDR     X0,[X0]             // point X0 to X0 address
    BL      free                // free node

    LDP     X0,X1,[SP],#16      // pop from stack
    STR     X1,[X0]             // store X0 address to X1

exit:    
    LDR     LR,[SP],#16         // pop from stack
    RET                         // return

    .end
