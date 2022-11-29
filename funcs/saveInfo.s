	.equ AT_FDCWD, 			-100	//a number assigned by the OS
    .equ CREATEWOT, 		01101 	//create-truncate file if does not exist for writing
    .equ  RW_RW__, 0640
    .data
    szFile:     .asciz  "./output.txt"
    szTmp:      .skip 60
    qdNxt:      .quad 0
    chLF:	    .byte 10
    iFD:		.byte 0
    .global saveInfo
    .text
saveInfo:
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
//prints to the file, run through all nodes and print
    MOV X19, X1
    MOV X20, X2

	MOV X0, #AT_FDCWD		//local directory	
	MOV X8, #56				//open at
	LDR X1,=szFile			//file name
	MOV X2, #CREATEWOT		//flag
	MOV X3, RW_RW__			//mode
	SVC 0					//service call
//svc returns fd in register X0
	LDR X1,=iFD
	STRB W0,[X1]


    MOV X0, X19  //move headptr
    LDR X0,[X0] //deref
    CMP X0, #0  //see contents
    B.EQ done   //exit
    LDR X0,[X0] //unload
    BL putstring//print

    MOV X0, X19      //back to head
    LDR X0,[X0]
    LDR X0,[X0, #8] //nxt ptr
    CMP X0, #0  //check null
    B.EQ done
    LDR X21,=qdNxt  //load var
    STR X0,[X21]    //store nxt ptr

loop:
//assume X1 and X2 contain head and tail ptr
    LDR X0,=qdNxt
    LDR X0,[X0]             //deref
    CMP X0, #0
    B.EQ done               //empty address for content
    LDR X0,[X0]
    BL putstring    //print

    LDR X0,[X21]            //deref node ptr
    LDR X0,[X0, #8]
    CMP X0, #0
    B.EQ done
    LDR X21,=qdNxt
    STR X0,[X21]
    B loop
done:
	LDR X1,=iFD				//load fd
	LDR X0,[X1]				//dereference

	MOV X8, #57				//load syscall close
	SVC 0					//call

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

printNode:
    STR x30, [SP, #-16]!    //push the link register so that when we branch we don't get messed
    LDR X6,=szTmp
    LDR X5,[X0]
    STR X5,[X6]
    LDR X0,=szTmp
    BL strlength
    

	MOV X8, #64				//write
//make sure X0 has fd in it
	LDR X1,=szTmp			//load string
	LDR X0,=szTmp
    BL strlength
    MOV X2, X0
	SVC 0					//service call

	LDR X1,=iFD				//load file ds
	LDRB W0, [X1]			//deref
	MOV X8, #64				//load syscall
	LDR X1,=chLF			//load newline
	MOV X2, #1				//load bytes
	SVC 0					//call

    LDR x30,[SP], #16       //pop off the SP and restore Link Register
    RET                     //exit
