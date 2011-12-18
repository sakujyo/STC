CC	= gcc

c1.exe	: c1.o myList.o
	$(CC) -o c1.exe c1.o myList.o
myList.o	: myList.h myList.c
	$(CC) -c myList.c
c1.o		: c1.c myList.h
	$(CC) -c c1.c
%.exe	: %.c
	$(CC) -o $*.exe $*.c
clean	:
	rm c1.exe
	rm c1.o
	rm myList.o
