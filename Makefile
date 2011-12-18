CC	= gcc

c1.exe	: c1.c
	$(CC) -o c1.exe c1.c
%.exe	: %.c
	$(CC) -o $*.exe $*.c
clean	:
	rm c1.exe
