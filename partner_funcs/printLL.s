// print linked list

    .global printLL
    .text

printLL:
    ADD     X30,X30,#4

    STR     LR,[SP,#-16]!   // push to stack
    LDR     X0,=headPtr     // point X0 to headPtr
    LDR     X0,[X0]         // point X0 to X0 address

list:
    CMP     X0,#0           // compare X0 to null
    B.EQ    exit            // exit

    STR     X0,[SP,#-16]!   // push to stack
    LDR     X0,[X0]         // point X0 to X0 address
    BL      putstring       // print string function

    LDR     X0,[SP],#16     // pop from stack
    LDR     X0,[X0,#8]      // point X0 to X0 address
    B       list            // loop

exit:
    LDR     LR,[SP],#16     // pop from stack
    RET                     // return

    .end
