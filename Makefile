CC	= gcc
LEX	= flex
YACC	= bison

skc.exe	: SkC.tab.c SkC.lex.yy.c trace.o myLib.o myList.o
	$(CC) -o skc.exe SkC.tab.c SkC.lex.yy.c trace.o myLib.o myList.o
dtrace	: trace.c
	$(CC) -DDEBUG -c trace.c
c2.exe	: c2.o myList.o myLib.o
	$(CC) -o c2.exe c2.o myList.o myLib.o
c1.exe	: c1.o myList.o myLib.o
	$(CC) -o c1.exe c1.o myList.o myLib.o
%.lex.yy.c	: %.l
	$(LEX) -8 -o $*.lex.yy.c $*.l
%.tab.c		: %.y
	$(YACC) --defines $*.y

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
	rm -f SkC.lex.yy.c
	rm -f SkC.tab.h
	rm -f SkC.tab.c
run	: skc.exe s.c myLib.o
	skc.exe s.c
	as -o s.o s.s
	c:/mingw/bin/../libexec/gcc/mingw32/4.6.1/collect2.exe -Bdynamic --verbose -o s.exe c:/mingw/bin/../lib/gcc/mingw32/4.6.1/../../../crt2.o c:/mingw/bin/../lib/gcc/mingw32/4.6.1/crtbegin.o -Lc:/mingw/bin/../lib/gcc/mingw32/4.6.1 -Lc:/mingw/bin/../lib/gcc -Lc:/mingw/bin/../lib/gcc/mingw32/4.6.1/../../../../mingw32/lib -Lc:/mingw/bin/../lib/gcc/mingw32/4.6.1/../../.. s.o myLib.o -lmingw32 -lgcc_eh -lgcc -lmoldname -lmingwex -lmsvcrt -ladvapi32 -lshell32 -luser32 -lkernel32 -lmingw32 -lgcc_eh -lgcc -lmoldname -lmingwex -lmsvcrt c:/mingw/bin/../lib/gcc/mingw32/4.6.1/crtend.o > link1log.txt

