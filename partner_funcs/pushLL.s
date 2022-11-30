// push to link list
// X0 - pointer to data to add to List

    .global pushLL
    .text

pushLL:
    ADD     X30,X30,#4
    
    STR     LR,[SP,#-16]!   // push to stack

// Create the new node
    STR     X0,[SP,#-16]!   // push to stack
    MOV     X0,#16          // load 1 node
    BL      malloc          // malloc memory

// Store address
    LDR     X1,[SP],#16     // pop from stack
    MOV     X3,X0           // move X0 to X3
    STR     X1,[X0],#8      // store X0 address to X1 and increment
    MOV     X1,#0           // move null to X1
    STR     X1,[X0]         // store X0 address to X1
    MOV     X0,X3           // move X3 to X0

// Insert
    LDR     X1,=tailPtr     // point X1 to tailPtr
    LDR     X2,[X1]         // point X2 to X1 address
    STR     X0,[X1]         // store X1 address to X0
    LDR     X1,=headPtr     // point X1 to headPtr
    LDR     X1,[X1]         // point X1 address to X1
    CMP     X1,#0           // compare X1 to null
    B.EQ    addHead         // if equal goto addHead

    STR     X0,[X2,#8]      // store X2 to X0
    B       increment       // add node

addHead:
    LDR     X1,=headPtr     // point headPtr to X1
    STR     X0,[X1]         // store X1 address to X0

increment:
    LDR     X0,=iNodes      // point iNodes
    LDR     X1,[X0]         // point X0 address to X1
    ADD     X1,X1,#1        // increment
    STR     X1,[X0]         // store X0 address to X1
    LDR     LR,[SP],#16     // pop form stack
    RET                     // return
    
    .end
