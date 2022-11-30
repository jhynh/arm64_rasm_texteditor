#creates the final driver
#alias
CC=as
#creation target
TARGET = driver
#dependencies and trigger word
all: driver.s funcs
	$(CC) -g -o driver.o driver.s
	ld -o $(TARGET) /usr/lib/aarch64-linux-gnu/libc.so driver.o -dynamic-linker /lib/ld-linux-aarch64.so.1 obj/int64asc.o obj/freeLL.o obj/findNode.o obj/putch.o obj/String_toLowerCase.o obj/string_Substring.o obj/String_Copy.o obj/String_Length.o ../obj/strlength.o ../obj/String_length.o ../obj/putstring.o ../obj/getstring.o ../obj/ascint64.o obj/printContent.o obj/inputInfo.o obj/editInfo.o obj/saveInfo.o obj/searchInfo.o obj/deleteInfo.o

funcs: funcs/printContent.s funcs/inputInfo.s funcs/editInfo.s funcs/saveInfo.s funcs/searchInfo.s funcs/deleteInfo.s funcs/string_Substring.s funcs/findNode.s funcs/freeLL.s
	$(CC) -g -o obj/printContent.o funcs/printContent.s
	$(CC) -g -o obj/inputInfo.o funcs/inputInfo.s
	$(CC) -g -o obj/editInfo.o funcs/editInfo.s
	$(CC) -g -o obj/saveInfo.o funcs/saveInfo.s
	$(CC) -g -o obj/searchInfo.o funcs/searchInfo.s
	$(CC) -g -o obj/deleteInfo.o funcs/deleteInfo.s
	$(CC) -g -o obj/string_Substring.o funcs/string_Substring.s
	$(CC) -g -o obj/findNode.o funcs/findNode.s
	$(CC) -g -o obj/freeLL.o funcs/freeLL.s