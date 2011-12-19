/* 
 * flex�p������
 */

/*** Definition section ***/
%{
/*
 * C �R�[�h�ɂ�C�̕W��I/O ���C�u�������g�����̂�����.
 * %{�� %} �ň͂܂ꂽ�����͂��̂܂ܐ����t�@�C���Ɏ�荞�܂��.
 */

#include "myList.h"
#include "SkC.tab.h"
extern YYSTYPE yylval;
void debug(const char *format, ...);
extern lineno;
//extern char *strLiteral;

%}

/* �}�N��;  ���K�\�� */

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
        // 2�i���A16�i���A8�i���̓v���t�B�N�X��������j�ōl���Ă݂�
	//UNARY_OPERATOR          [\+\-]
        // �Ƃ肠�������ꂾ��
PLUSPLUS                \+\+
MINUSMINUS              \-\-
OP_ASSIGNMENT           =

HEXDIGIT            [a-f]
HEXINT              0x({DIGIT}|{HEXDIGIT})+
STRINGPAT           \".*\"
        //LABEL               [a-zA-Z][0-9a-zA-Z]+
                    /* ���̂Ƃ��뒷�������Ȃ� */

        //LABELDEFINITION     {LABEL}:


/* �����flex�ɓ��̓t�@�C������ł��邱�Ƃ�����. */
%option noyywrap

%%
    /*
     * �K���̈�
     *
     * �R�����g�̓C���f���g���Ȃ���΂Ȃ�Ȃ�.
     * �������Ȃ��Ɛ��K�\���ƌ�F�����Ă��܂�.
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
                 * ���̋K���͓��͂��琮����\������.
                 * yytext�ɂ͈�v���������񂪊܂܂��.
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
                return yytext[0]; /*����ȊO�����̂܂ܕԂ��Ă݂� */
            }

%%
/*** C�R�[�h�̈� ***/

//YYSTYPE yylval;
/*int main(void)
{
        FILE *yyin = stdin;
        debug("test\n");
        yylex();
        return 0;
        }
*/