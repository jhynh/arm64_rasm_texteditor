	.equ CREATERW, 00102    //read/write and create if doesn't exist
	.equ AT_FDCWD,  -100	//a number assigned by the OS
	.equ RW_RW__,   0640    //owner & group has read and write
    .data
    chRead:         .byte   1
    szFile:     .asciz  "./input.txt"
    iFD:            .byte   0
    szLine:         .skip   56
    headPtr:        .quad   0
    tailPtr:        .quad   0
    newNode:        .quad   0
    .global inputInfo
    .text
inputInfo:
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
    LDR X3,=headPtr
    LDR X4,=tailPtr
    LDR X1,[X1]
    STR X1,[X3]
    LDR X2,[X2]
    STR X2,[X4]
//gets user input either from a file or keyboard, insert end of LL, grab my init code and run it with input.txt
    
readIn:
//-------------------------------------------------------------------------------
//collect info from text file
//-------------------------------------------------------------------------------

//opens file
    MOV X0, #AT_FDCWD               //dfd for openat
    MOV X8, #56                     //sys call #
    LDR X1,=szFile                  //file name
    MOV X2,#CREATERW                //flags
    MOV X3, RW_RW__                 //mode
    SVC 0                           //service call

//store FD
    LDR X19,=iFD                    //load
    STRB W0,[X19]                   //store fd

//save
LDR X22,=szLine
//retrieve a byte
loop:
    LDR X29,=headPtr
    LDR X28,=tailPtr
    LDR X1,=iFD                     //load
    LDRB W0,[X1]                    //deref
    MOV X8, #63                     //sys call #
    LDR X1,=chRead                  //read in char
    MOV X2, #1                      //# of bytes
    SVC 0                           //call

//end?
    CMP X0, #0                      //EOF
    B.EQ doneLine                   //exit

//store character
    LDRB W0,[X1]                    //unload the char
    STRB W0,[X22]                    //store into X22
    ADD X22, X22, #1
//newline?
    CMP X0, #10                     //newline
    B.EQ storeLine                  //store

    B loop

doneLine:
    MOV X23, #1
//now parse content.txt until EOF and store each line into a node
storeLine:
//allocate space for headPtr and tailPtr, string will be in X21
    LDR X21,=szLine
    MOV X0, X21
    BL strlength
    ADD X0, X0, #1
    MOV X28, X0
    BL insertLast
    LDR X22,=szLine
    MOV X0, #0
//clears out all bytes in szLine
    STR X0,[X22]
    ADD X22, X22, #8
    STR X0,[X22]
    ADD X22, X22, #8
    STR X0,[X22]
    ADD X22, X22, #8
    STR X0,[X22]
    ADD X22, X22, #8
    STR X0,[X22]
    LDR X22,=szLine
    CMP X23, #1
    B.EQ done
    B loop
//load head & tail ptr in X1 and X2
done:
    //close file
    LDR X1,=iFD         //load fd
    LDR X0,[X1]         //deref
    MOV X8, #57         //load exit
    SVC 0               //syscall
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

    //------------------------------------------------------------------------------------
//node functions
//------------------------------------------------------------------------------------
insertLast:
    STR x30, [SP, #-16]!    //push the link register so that when we branch we don't get messed
    //create new node
    MOV X0, X28             //move 16 bytes in, then malloc that size
    BL malloc

    LDR X1,=newNode         //store the malloced space into the newNode
    STR X0,[X1]             //create copy of kbuf into newly malloced string
    MOV X0, X21
    BL String_Copy          //newnode->data = new string //newnode->next = nullptr
    LDR X0,[X0]
    LDR X1,=newNode
    LDR X1,[X1]
    STR X0,[X1]             //store the quad into the 8 bytes of node's data //storing the next as null
    LDR X1,=newNode
    LDR X1,[X1]
    MOV X3, #0
    ADD X1, X1, #8          //make X1 -> NEXT FIELD (next)
    STR X3, [X1]            //store null into next field

    //newdata = the address of the new string
    LDR X0,=headPtr
    LDR X0,[X0]
//------------------------------------------------------------------------------------
//if empty create tail & head to newnode
    CBNZ X0, NOTEMPTY

//B.NE NOTEMPTY
    LDR X1,=newNode         //newNode is a double ptr
    LDR X1,[X1]

    LDR X0,=headPtr
    STR X1,[X0]             //head = newNode

    LDR X0,=tailPtr
    STR X1,[X0]             //tail = newNode

    B INSERTEND             //exit
//------------------------------------------------------------------------------------
    NOTEMPTY:
    //if the head is not null, then we set the tail's next to the nwe node and the tailptr to newNode, since tail,next, is pointing to null
    LDR X0,=tailPtr
    LDR X0,[X0]

    LDR X1,=newNode
    LDR X1,[X1]             //doesn't change X0
    STR X1,[X0, #8]         //tail ptr->nxt = newnode

    LDR X0,=tailPtr
    STR X1,[X0]

    INSERTEND:
    LDR X1,=newNode
    MOV X0, #0
    STR X0,[X1]
    LDR x30,[SP], #16       //pop off the SP and restore Link Register
    RET                     //exit


//newnode->data = nullptr