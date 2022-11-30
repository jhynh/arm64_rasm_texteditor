// erase from linked list given an index
// X0 - index to erase

    .global eraseLL
    .text
    
eraseLL:
    ADD     X30,X30,#4

    STR     LR,[SP,#-16]!   // push to stack
    MOV     X3,X0           // move X0 to X3
    MOV     X2,#0           // move null to X2
    LDR     X0,=headPtr     // point X0 to headPtr
    LDR     X0,[X0]         // point X0 to X0 address

search:
    CMP     X0,#0           // compare X0 to 0
    B.EQ    exit            // if equal goto exit

    CMP     X2,X3           // compare X2 to X3
    B.EQ    link            // if equal goto link
    
    ADD     X2,X2,#1        // increment X2
    ADD     X0,X0,#8        // increment X0
    MOV     X1,X0           // move X0 to X1
    LDR     X0,[X0]         // point X0 to X0 address
    B       search          // loop

link:
    ADD     X2,X0,#8        // increment X0 and store in X2
    LDR     X2,[X2]         // point X2 to X2 address
    CMP     X2,#0           // compare X2 to null
    B.EQ    tail            // if equal goto tail

    CMP     X3,#0           // compare X3 to null
    B.EQ    head            // if equal goto head

    STR     X2,[X1]         // store X1 address to X2
    B       clear           // goto clear

head:
    LDR     X3,=headPtr     // point X3 to headPtr
    STR     X2,[X3]         // store X3 address to X2
    B       clear           // clear node

tail:
    LDR     X3,=tailPtr     // point X3 to tailPtr
    SUB     X2,X1,#8        // decrement X1 to X2
    STR     X2,[X3]         // store X3 address to X2

clear:
    STR     X0,[SP,#-16]!   // push to stack
    LDR     X0,[X0]         // point X0 to X0 address
    BL      free            // free string

    LDR     X0,[SP],#16     // pop from stack
    BL      free            // free node

    LDR     X0,=iNodes      // point X0 to iNodes
    LDR     X1,[X0]         // point X1 to X0 address
    SUB     X1,X1,#1        // decrement X1
    STR     X1,[X0]         // store X0 address to X1

exit:    
    LDR     LR,[SP],#16     // pop to stack
    RET                     // return

    .end
