//***************************************************************************** 
//Names: Homayoun Nistanaki, Jason Huynh (GROUP 14)
//Program:  RASM4.s 
//Class: CS 3B 
//Lab:  RASM4
//Date: November 23, 2022 at 11:00 PM 
//Purpose: 
// create a pseudo text editor using ARM64 with persistent data, using external functions and accept input txt files
//******************************************************************************/
	.equ CREATERW, 00102    //read/write and create if doesn't exist
	.equ AT_FDCWD,  -100	//a number assigned by the OS
	.equ RW_RW__,   0640    //owner & group has read and write
    .data                   //data segment

//variables
//-------------------------------------------------------------------------------
    szpromptGuard1: .asciz  "------------------------------------------------------------------------------------------------------------------\n"
    szTitle:        .asciz  "RASM4 TEXT EDITOR\nData Structure Heap Memory Consumption: 00000000 bytes\nNumber of Nodes: 0\n"
    szPrompt1:      .asciz  "<1> View all strings\n"
    szPrompt2:      .asciz  "<2> Add string\n    <A> from Keyboard\n    <B> from File. Static file name input.txt\n\n"
    szPrompt3:      .asciz  "<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node).\n"
    szPrompt4:      .asciz  "<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed.\n"
    szPrompt5:      .asciz  "<5> String search. Regardless of case, return all strings that match the substring given.\n"
    szPrompt6:      .asciz  "<6> Save File (output.txt)\n"
    szPrompt7:      .asciz  "<7> Quit\n"
    szpromptGuard2: .asciz  "------------------------------------------------------------------------------------------------------------------\n"

    szFile1:        .asciz  "./output.txt"
    szFile2:        .asciz  "./input.txt"

    chRead:         .byte   1
    readBuff:       .skip   56
    inputBuff:      .skip   56
    chLF:           .byte   10
    iFD:            .byte   0
    szLine:         .skip   56
    headPtr:        .quad   0
    tailPtr:        .quad   0
    newNode:        .quad   0
//-------------------------------------------------------------------------------

    .global _start                  //global label
    .text                           //text segment

_start:

readIn:
//-------------------------------------------------------------------------------
//collect info from text file
//-------------------------------------------------------------------------------

//opens file
    MOV X0, #AT_FDCWD               //dfd for openat
    MOV X8, #56                     //sys call #
    LDR X1,=szFile1                 //file name
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
printMenu:
//-------------------------------------------------------------------------------
    LDR X0,=szpromptGuard1          //load
    BL putstring                    //print
    LDR X0,=szTitle                 //load
    BL putstring                    //print
    LDR X0,=szPrompt1               //load
    BL putstring                    //print
    LDR X0,=szPrompt2               //load
    BL putstring                    //print
    LDR X0,=szPrompt3               //load
    BL putstring                    //print
    LDR X0,=szPrompt4               //load
    BL putstring                    //print
    LDR X0,=szPrompt5               //load
    BL putstring                    //print
    LDR X0,=szPrompt6               //load
    BL putstring                    //print
    LDR X0,=szPrompt7               //load
    BL putstring                    //print
    LDR X0,=szpromptGuard2          //load
    BL putstring                    //print
//-------------------------------------------------------------------------------
    LDR X0,=inputBuff
    MOV X1, 2
    BL getstring

    LDR X0,=inputBuff
    BL ascint64
    MOV X20, X0
//store last line and load, then exit
    LDR X1,=headPtr
    LDR X2,=tailPtr
//switch statement
    CMP x20, 1
    B.NE switch
    BL printContent
    B printMenu
switch:
    CMP X20, 2
    B.NE switch2
    BL inputInfo
    B printMenu
switch2:
    CMP X20, 3
    B.NE switch3
    BL deleteInfo
    B printMenu
switch3:
    CMP X20, 4
    B.NE switch4
    BL editInfo
    B printMenu
switch4:
    CMP X20, 5
    B.NE switch5
    BL searchInfo
    B printMenu
switch5:
    cmp X20, 6
    B.NE exit
    BL saveInfo
    B printMenu

exit:   
    BL freeLL
    MOV X0, #0				    	//use 0 return code
    MOV X8, #93					    //service code 93 terminate
    SVC 0				    		//call linux to terminate

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
    .end
