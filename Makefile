CC	= gcc

c2.exe	: c2.o myList.o myLib.o
	$(CC) -o c2.exe c2.o myList.o myLib.o
c1.exe	: c1.o myList.o myLib.o
	$(CC) -o c1.exe c1.o myList.o myLib.o
myList.o	: myList.h myList.c
	$(CC) -c myList.c
myLib.o		: myLib.h myLib.c
	$(CC) -c myLib.c
c1.o		: c1.c myList.h myLib.h
	$(CC) -c c1.c
c2.o		: c2.c myList.h myLib.h
	$(CC) -c c2.c
%.exe	: %.c
	$(CC) -o $*.exe $*.c
clean	:
	rm -f c1.exe
	rm -f c1.o
	rm -f myList.o
	rm -f myLib.o
	rm -f c2.exe
	rm -f c2.o
