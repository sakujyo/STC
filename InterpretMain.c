/*
 * メインプログラム.
 *
 * 字句解析を呼び出し、処理が済むと終了する. 
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include <stdarg.h>

#define MAXFNLEN    (251)           // アセンブリ・ソースの".z80"を除いた最大長さ

int mystrncasecmp(const char *s1, const char *s2, size_t n);
void debug(const char *format, ...);
void trace(const char *format, ...);
char *copySL(const char *str);

extern FILE *yyin;
char *strLiteral;
FILE *fpc;	// C source

int main(int argc, char *argv[])
{
    //int result;
    int result, fnLen;
    char fns[MAXFNLEN + 4 + 1];

    if ((argc != 2) || (strlen(argv[1]) < 2) || (mystrncasecmp(argv[1] + strlen(argv[1]) - 2, ".C", (size_t)2) != 0)) {
        printf("Usage: %s C_source.c\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    fnLen = strlen(argv[1]) - (size_t)2;
    if (fnLen > MAXFNLEN) fnLen = MAXFNLEN;
    strncpy(fns, argv[1], fnLen);
    strncpy(fns + fnLen, ".s", 3);
    fprintf(stderr, "ASM(gas) Filename: \%s\n", fns);
    fpc = fopen(argv[1], "r");
    if (!fpc) {
        fprintf(stderr, "Can't open source: \%s\n", argv[1]);
        exit(EXIT_FAILURE);
    }
    fps = fopen(fns, "wb");

    yyin = fpc;
    fprintf(fps, ""
"	.file	\"s.c\"\n"
"	.def	___main;	.scl	2;	.type	32;	.endef\n"
"	.text\n"
"	.globl	_main\n"
"	.def	_main;	.scl	2;	.type	32;	.endef\n"
"_main:\n"
"LFB6:\n"
"	.cfi_startproc\n"
"	pushl	%%ebp\n"
"	.cfi_def_cfa_offset 8\n"
"	.cfi_offset 5, -8\n"
"	movl	%%esp, %%ebp\n"
"	.cfi_def_cfa_register 5\n"
"	andl	$-16, %%esp\n"
		    "	subl	$32, %%esp\n"
"	call	___main\n"
"");
    result = yyparse();
    fprintf(fps, ""
//"	movl	$123, 12(%%esp)\n"
"	leave\n"
"	.cfi_restore 5\n"
"	.cfi_def_cfa 4, 4\n"
"	ret\n"
"	.cfi_endproc\n"
"LFE6:\n"
"	.def	_putchar;	.scl	2;	.type	32;	.endef\n"
	   );
    //if (result) return result;

    return result;
}

char *copySL(const char *str)
{
	char *p;
	int len = strlen(str);

	p = malloc(len - 2 + 1);	// 両端のダブルクォーテーションを取り除き、ヌル文字を付加する。
	strncpy(p, str + 1, len - 2);
	p[len - 2] = '\0';

	return p;
}

/* Called by yyparse on error.  */
void yyerror (char const *s)
{
	fprintf(stderr, "Syntax error: line %d\n", lineno);
    fprintf (stderr, "%s\n", s);
}

int mystrncasecmp(const char *s1, const char *s2, size_t n)
{
    char c1, c2;
    while (n > 0) {
        c1 = tolower(*s1);	s1++;
        c2 = tolower(*s2);	s2++;
        if (c1 < c2) return -1;
        if (c1 > c2) return 1;
        n--;
    }
    return 0;
}

void trace(const char *format, ...)
{
    va_list argp;

    va_start(argp, format);
    //vfprintf(stderr, format, argp);
}
