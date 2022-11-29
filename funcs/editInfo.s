//todo: both edit info and input info need to be on a new line, so compare if it's a head or tail, add \n accordingly, and if in middle, add \n to start & end
//thankfully, editinfo does not touch the nodes themselves, but simply the node->data ptr
    .data
    szPrompt:   .asciz  "------------EDITING------------\n"
    szPrompt1:  .asciz  "Enter a string: "
    szReplace:  .skip   48
    .global editInfo
    .text
editInfo:
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
//opens to a node and overwrites with a user inputted string
    MOV X19, X1             //store head
    MOV X20, X2             //store tail
    
    LDR X0,=szPrompt        //load
    BL putstring            //print
    LDR X0,=szPrompt1       //load
    BL putstring            //print
    
    LDR X0,=szReplace       //load var
    MOV X1, #48             //move bytes
    BL getstring            //get string

    MOV X1, X19             //load head
    MOV X2, X20             //load tail
    BL findNode             //call index finder
    //returns address to node
    MOV X19,X0              //store it somewhere else
    LDR X0,[X0]             //deref
    BL free                 //free the string

//allocate the new string, load the node, and store in node->data
    LDR X0,=szReplace       //load new strng
    BL strlength            //get length
    BL malloc               //allocate
    LDR X1,=szReplace       //load it
    LDR X1,[X1]
    STR X1,[X0]     //store the string into mallocd space
    MOV X1,X19      //load the node itself
    STR X0,[X1]     //store the mallocd space inside

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

    