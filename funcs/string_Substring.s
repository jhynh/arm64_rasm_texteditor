//--------------------------------------------------------------------------------------------------------------------------
//search for sub array in the string,return true or false in X0, subarray passed in X1, start of string in X2
//--------------------------------------------------------------------------------------------------------------------------
    .data
    qdCopy1:        .quad 0
    qdCopy2:        .quad 0
    .global string_Substring
    .text

string_Substring:
    //need stack here since malloc and ptr for starting
    STR X19, [SP, #-16]!		    // PUSH for ptr
    STR X20, [SP, #-16]!		    // PUSH for ptrStart
    STR X21, [SP, #-16]!		    // PUSH for grabbing a char
    STR X22, [SP, #-16]!		    // PUSH for counter
    STR X23, [SP, #-16]!		    // PUSH for var
    STR X30, [SP, #-16]!		    // PUSH LR
    //counter
    MOV X25, 0

    MOV X19, X1
    MOV X20, X2

    MOV X0, X19
    BL String_Copy
    LDR X1,=qdCopy1
    LDR X0,[X0]
    STR X0,[X1]

    MOV X0,X20
    BL String_Copy
    LDR X1,=qdCopy2
    LDR X0,[X0]
    STR X0,[X1]

    LDR X19,=qdCopy1
    LDR X0,[X19]
    BL String_toLowerCase
    LDR X20,=qdCopy2
    LDR X0,[X20]
    BL String_toLowerCase
    LDR X19,[X19]
    LDR X20,[X20]

    MOV X0, X19
    BL strlength                    //get length
    MOV X21, X0                     //store length
    SUB X21, X21, #1

loop:
    LDRB W22, [X19], #1              //grab a byte

loop2:
    LDRB W23, [X20], #1
    CMP X23, X22
    B.EQ add
    CMP X23, #0
    B.EQ false
    B loop2 
add:
    ADD X25, X25, #1
    CMP X25, X21
    B.EQ true
    B loop

true:
    MOV X19, #1
    B done
false:
    MOV X19, #0
done:
    LDR X0,=qdCopy1
    LDR X0,[X0]
    BL free
    LDR X0,=qdCopy2
    LDR X0,[X0]
    BL free

    MOV X0,X19
    LDR X30, [SP], #16			    // POP print
    LDR X23, [SP], #16			    // POP print
    LDR X22, [SP], #16			    // POP print
    LDR X21, [SP], #16			    // POP print
    LDR X20, [SP], #16			    // POP print
    LDR X19, [SP], #16			    // POP print
    RET LR
    //loop through the string, only store if within the range

