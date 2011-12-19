/* SkC Sakujyo Toy C Compiler (Limited Semantics ans Syntax). */

%{
    	//#define YYSTYPE int
        #include <stdio.h>
        #include <stdlib.h>
	#include "myLib.h"
	#include "myList.h"
	//#include "parser.h"

    	extern char *yytext;        // これ必要。重要。
    	int yylex(void);
    	int yyparse(void);
    	void yyerror (char const *);
    	//void yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep);
	int lineno = 0;		// 行番号
	char *copySL(const char *str);
	FILE *fps;	// ASM(gas) source

%}
%union _YYSTYPE {
	int intval;
	Node *nodeptr;
	List *listptr;
}

%token  INT
%token  RETURN
%token  INTEGER_CONSTANT
%token  IDENTIFIER
%token  UNARY_OPERATOR
%token  PLUSPLUS
%token  MINUSMINUS
%token  OP_ASSIGNMENT
%token  OP_UNARY
%token	STRING_LITERAL

%type <listptr> multiplicative_expression
%type <nodeptr> primary_expression postfix_expression unary_expression cast_expression
%type <intval> INTEGER_CONSTANT constant additive_expression assignment_expression conditional_expression

	/*%union {
  		int intval;
  		double val;
  		char *tptr;
	}*/

%% /* Grammar rules and actions follow.  */

translation_unit:               /* EMPTY */
                                external_declaration
                                | translation_unit external_declaration
                                ;
external_declaration:           declaration
		    		| function_definition
                                ;
function_definition:            declaration_specifiers declarator compound_statement
                                ;
declarator:                     direct_declarator       /* pointer? direct_declarator */
                                ;
direct_declarator:              IDENTIFIER      {printf("%s -> direct_declarator\n", yytext); }
                                | direct_declarator '(' parameter_type_list ')'
                                ;
compound_statement:             '{' block_item_list_opt '}'
                                ;
parameter_type_list:            parameter_list
                                | parameter_type_list parameter_list
                                ;
parameter_list:                 parameter_declaration
                                | parameter_list ',' parameter_declaration
                                ;
parameter_declaration:          declaration_specifiers declarator
                                ;
block_item_list_opt:            /* EMPTY */
                                | block_item_list
                                ;
block_item_list:                block_item
                                | block_item_list block_item
                                ;
block_item:                     declaration
                                | statement
                                ;
statement:                      expression_statement
                                | jump_statement
                                ;
expression_statement:           expression_opt ';'      //expression_opt ';'
                                ;
expression_opt:                 /* EMPTY */
                                | expression
                                ;
expression:                     assignment_expression
                                | expression assignment_expression
                                ;
jump_statement:                 RETURN expression_opt ';'
                                ;
primary_expression:             IDENTIFIER      	{
		  		printf("IDENTIFIER \"%s\" -> primary_expression\n", yytext); 
				//ちょっとだけ試させて
				//構文木作らないとやっぱだめ fprintf(fps, "\tmovl	$_%s, (%%esp)\n", yytext);
				$$ = newNodeString(yytext);
				}
                                | constant		
				{ //$$ = $1; 
				$$ = newNodeInt($1);
				printf("constant %d -> primary_expression\n", $1);
				fprintf(fps, "\tmovl	$%d, (%%esp)\n\tcall	_push\n", $1);
				}
				| STRING_LITERAL	{
				printf("STRING LITERAL \"%s\" -> primary_expression\n", yytext); 
				$$ = newNodeString(yytext);
				}
                                ;
constant:                       INTEGER_CONSTANT	{ $$ = $1; }
                                ;
/*
string_literal:			'"' s_char_sequence_opt '"'
	      			;
s_char_sequence_opt:		/* EMPTY */
/*		   		| s_char_sequence
				;
s_char_sequence:		s_char
	       			| s_char_sequence s_char
				;
*/
assignment_expression:          conditional_expression					{ $$ = $1; }
                                | unary_expression assignment_operator assignment_expression
				{ fprintf(fps, "	movl	$%d, 28(%%esp)\n", $3); printf("u_e = a_e(%d) -> a_e\n", $3); }
                                ;
conditional_expression:         additive_expression	{ $$ = $1; }
		      		;
additive_expression:		multiplicative_expression				{}/*{ $$ = $1; }*/
		   		| additive_expression '+' multiplicative_expression	{/*{ $$ = $1 + $3; }*/
					fprintf(fps, "\tcall	_sadd\n");
				}
				| additive_expression '-' multiplicative_expression	{/*{ $$ = $1 - $3; }*/
				}
				;
multiplicative_expression:	cast_expression						{}/*{ $$ = $1; }*/
			 	| multiplicative_expression '*' cast_expression		{ 
				/*$$ = $1 * $3;*/
				/*List *l;
				Node *n1, *n2, *n3;
				l= newList();
				n1 = newNodeMul();
				n2 = newNodeInt($1);
				n3 = newNodeInt($3);
				ListAdd(l, n1); ListAdd(l, n2); ListAdd(l, n3);
				$$ = l;*/

				fprintf(fps, "\tcall	_smul\n");
				}
			 	| multiplicative_expression '/' cast_expression		{}
				/*{$$ = $1 * $3; }*/
			 	| multiplicative_expression '%' cast_expression		{}
				/*{$$ = $1 * $3; }*/
				;
cast_expression:                unary_expression					{ $$ = $1; }
	       			;
assignment_operator:            OP_ASSIGNMENT   {printf("assignment \"=\" op reducing...\n"); }
                                ;
postfix_expression:             primary_expression					{ $$ = $1; }
				// postfix_expression '(' argument_expression_list? ')'
                                | postfix_expression '(' argument_expression_list_opt ')'	{ 
				printf("po_e ( a_e_l_o ) -> po_e\n"); 
				/*fprintf(fps, "\tmovl	28(%%esp), %%eax\n\tmovl	%%eax, (%%esp)\n\tcall	_putchar\n");*/
				fprintf(fps, "\tmovl	$1, 4(%%esp)\n\tmovl	$_%s, (%%esp)\n\tcall	_funcCall\n", (char *)($1->val));
				}
                                | postfix_expression PLUSPLUS
                                | postfix_expression MINUSMINUS
                                ;
argument_expression_list:       assignment_expression
                                | argument_expression_list ',' assignment_expression	// 関数呼び出しの実引数リスト？
                                ;
argument_expression_list_opt:   /* EMPTY */
                                | argument_expression_list
                                ;
unary_expression:               postfix_expression		{ $$ = $1; }
                                | PLUSPLUS unary_expression	{ $$ = $2; /*単なる衝突回避の一時しのぎ*/ }
                                | MINUSMINUS unary_expression	{ $$ = $2; /*単なる衝突回避の一時しのぎ*/ }
                                //| UNARY_OPERATOR unary_expression       // UNARY_OPERATOR cast_expression
                                //| '+' unary_expression       // UNARY_OPERATOR cast_expression
                                //| '-' unary_expression       // UNARY_OPERATOR cast_expression
                                ;

declaration:                    declaration_specifiers init_declarator_list_opt ';';
declaration_specifiers:         type_specifier declaration_specifiers_opt ;
declaration_specifiers_opt:     /* EMPTY */
                                | declaration_specifiers
                                ;
init_declarator_list_opt:       /* EMPTY */
                                | init_declarator_list
                                ;
init_declarator_list:           init_declarator
                                | init_declarator_list init_declarator
                                ;
init_declarator:                declarator ;
type_specifier:                 INT ;

%%

#include "InterpretMain.c"

