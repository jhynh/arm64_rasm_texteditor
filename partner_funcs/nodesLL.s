// return size of nodes

    .global nodesLL
    .text

nodesLL:
    ADD     X30,X30,#4

    LDR     X0,=iNodes      // point X0 to iNodes
    LDR     X0,[X0]         // point X0 to X0 address
    RET                     // return

    .end
