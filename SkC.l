/* 
 * flex用字句解析
 */

/*** Definition section ***/
%{
/*
 * C コードにはCの標準I/O ライブラリを使うものがある.
 * %{と %} で囲まれた部分はそのまま生成ファイルに取り込まれる.
 */

#include "myList.h"
#include "SkC.tab.h"
extern YYSTYPE yylval;
void debug(const char *format, ...);
extern lineno;
//extern char *strLiteral;

%}

/* マクロ;  正規表現 */

delim                   [ \t]
whitesp                 {delim}+
        //comment                 ;.*$

INT                     "int"
RETURN                  "return"
DIGIT                   [0123456789]
NONDIGIT                [abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]
_IDENTIFIER             {NONDIGIT}({NONDIGIT}|{DIGIT})*
ZENKAKU			[\x81-\x84\x88-\x89][\x40-\x7e\x80-\xfc]
IDENTIFIER              ({NONDIGIT}|{ZENKAKU})({NONDIGIT}|{DIGIT}|{ZENKAKU})*
INTEGER_CONSTANT        {DIGIT}+
        // 2進数、16進数、8進数はプリフィクスをつける方針で考えてみる
	//UNARY_OPERATOR          [\+\-]
        // とりあえずこれだけ
PLUSPLUS                \+\+
MINUSMINUS              \-\-
OP_ASSIGNMENT           =

HEXDIGIT            [a-f]
HEXINT              0x({DIGIT}|{HEXDIGIT})+
STRINGPAT           \".*\"
        //LABEL               [a-zA-Z][0-9a-zA-Z]+
                    /* 今のところ長さ制限なし */

        //LABELDEFINITION     {LABEL}:


/* これはflexに入力ファイルが一つであることを示す. */
%option noyywrap

%%
    /*
     * 規則領域
     *
     * コメントはインデントしなければならない.
     * そうしないと正規表現と誤認識してしまう.
     */

{INT}                   {
                                debug("Saw an Keyword INT %s\n", yytext);
                                //yylval = 7;
                                return INT;
                        }

{RETURN}                {
                                debug("Saw an Keyword RETURN %s\n", yytext);
                                return RETURN;
                        }

{INTEGER_CONSTANT}      {
                /*
                 * この規則は入力から整数を表示する.
                 * yytextには一致した文字列が含まれる.
                 */
                debug("Saw an Integer CONSTANT: %s\n", yytext);
                sscanf(yytext, "%d", &yylval);
                return INTEGER_CONSTANT; 
                }

{IDENTIFIER}    {
                        debug("Saw an IDENTIFIER: %s\n", yytext);
                        return IDENTIFIER;
                }

{OP_ASSIGNMENT}         {
                                debug("Saw an op(=): %s\n", yytext);
                                return OP_ASSIGNMENT;
                        }

	/*{UNARY_OPERATOR}        {
                                debug("Saw an op(%s)\n", yytext);
                                return OP_UNARY;
                        }*/

{PLUSPLUS}              {
                                debug("Saw an op(%s)\n", yytext);
                                return PLUSPLUS;
                        }

{MINUSMINUS}            {
                                debug("Saw an op(%s)\n", yytext);
                                return MINUSMINUS;
                        }

{whitesp}   {
                /* No action and no return */
            }

\n          {
                /* No return */
                lineno++;
            }

\".*\"		{
			return STRING_LITERAL;
		}
		
.           {
		printf("Saw an LETTER \"%c\"\n", yytext[0]);
                return yytext[0]; /*それ以外をそのまま返してみる */
            }

%%
/*** Cコード領域 ***/

//YYSTYPE yylval;
/*int main(void)
{
        FILE *yyin = stdin;
        debug("test\n");
        yylex();
        return 0;
        }
*/
