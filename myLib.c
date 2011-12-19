#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "myLib.h"
int stack[4096];
int sp = 0;

void printLnInt(int v)
{
	printf("%d\n", v);
}

char *copystr(const char *src)
{
	char *p;
	p = malloc(strlen(src) + 1);
	strcpy(p, src);
	return p;
}

void funcCall(int func(), int args)
{
	//int‚Ìˆø”‚ğ•¡”ó‚¯æ‚èAint‚ğ•Ô‚·ŠÖ”‚ÉŒÀ’è
	int a1, a2, a3, a4;
	switch (args) {
		case 1:
			a1 = pop();
			push(func(a1));
			break;
		case 2:
			a1 = pop();
			a2 = pop();
			push(func(a1, a2));
			break;
		default:
			//‰½‚à‚µ‚È‚¢
			break;
	}

	/*if (args == 2) {
		push(func(a1, a2));
	} else {
		//return 0;
	}*/
}

void push(int a)
{
	stack[sp] = a;
	sp++;
}

int pop(void)
{
	--sp;
	return stack[sp];
}

void sadd(void)
{
	push(pop() + pop());
}

void smul(void)
{
	push(pop() * pop());
}

int add(int a1, int a2)
{
	return a1 + a2;
}

int mul(int a1, int a2)
{
	return a1 * a2;
}

int add4(int a1, int a2, int a3, int a4)
{
	return a1 + a2 + a3 + a4;
}
