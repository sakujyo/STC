#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "myList.h"

Node *newNodeInt(int val)
{
	Node *n;
	int *p;
	n = malloc(sizeof(Node));
	p = malloc(sizeof(int));
	*p = val;
	n->type = INT;
	n->val = p;
	return n;
}

Node *newNodeDouble(double val)
{
	Node *n;
	double *p;
	n = malloc(sizeof(Node));
	p = malloc(sizeof(double));
	*p = val;
	n->type = DOUBLE;
	n->val = p;
	return n;
}

Node *newNodeString(char *s)
{
	Node *n;
	char *p;
	n = malloc(sizeof(Node));
	p = malloc(strlen(s) + 1);
	strcpy(p, s);
	n->type = STRING;
	n->val = p;
	return n;
}

Node *newNodeMul(void)
{
	Node *n;
	//int *p;
	n = malloc(sizeof(Node));
	//p = malloc(sizeof(int));
	n->type = MUL;
	//n->val = p;
	return n;
}

Node *newNodeFunc(void)
{
	Node *n;
	n = malloc(sizeof(Node));
	n->type = FUNCCALL;
	return n;
}

Node *newNodeList(List *l)
{
	Node *n;
	List *p;
	n = malloc(sizeof(Node));
	p = malloc(sizeof(List));
	p->length = l->length;
	p->head = l->head;
	p->tail = l->tail;
	n->type = LIST;
	n->val = p;
	return n;
}

void NodePrint(Node *n)
{
	switch (n->type) {
		case INT:
			printf("%d", *((int *)(n->val)));
			break;
		case DOUBLE:
			printf("%lf",*((double *)(n->val)));
			break;
		case STRING:
			printf("\"%s\"", (char *)(n->val));
			break;
		case LIST:
			printf("LIST:length %d", ((List *)(n->val))->length);
			break;
		case MUL:
			printf("*");
			break;
		case FUNCCALL:
			printf("FUNCCALL");
			break;
		default:
			break;
	}
}

void destructNode(Node *n)
{
	free(n);
}

List *newList(void)
{
	List *l;
	l = malloc(sizeof(List));
	l->length = 0;
	return l;
}

void destructList(List *l)
{
	free(l);
	/* TODO: destruct Nodes */
}

void ListAdd(List *l, Node *n)
{
	if (l->length == 0) {
		l->head = n;
		l->tail = n;
		l->length = 1;
	} else {
		l->tail->next = n;
		l->tail = n;
		l->length = l->length + 1;
	}
}

void ListPrint(List *l)
{
	int i;
	Node *n;
	n = l->head;
	printf("(");
	for (i = 0; i < l->length; i++) {
		//printf("%d", n->val);
		NodePrint(n);
		if (n != l->tail) {
			printf(", ");
			n = n->next;
		}
	}
	printf(")\n");
}

void ListRemove(List *l, Node *n)
{
	//ƒŠƒXƒgl ‚©‚çÅ‰‚ÉŒ©‚Â‚©‚Á‚½ n ‚ð‚Æ‚è‚Ì‚¼‚­
	int i;
	Node *p;
	if (l->length == 0) return;
	p = l->head;
	//æ“ª—v‘f‚Ì”äŠr
	if (l->length == 1) {
		if (p == n) {
			l->length = 0;
		}
		return;
	} else {
		if (p == n) {
			l->length = l->length - 1;
			l->head = p->next;
			return;
		}
	}

	/*if (p == n || l->length == 1) {
		if (p == n) {
			l->length = l->length - 1;
			if (l->length > 0) {
				l->head = p->next;
			}
		}
		return;
	}*/


	/*if (p == n) {
		l->length = l->length - 1;
		if (l->length != 0) {
			l->head = p->next;
		}
		return;
	}
	if (l->length == 0) {
		return;
	}*/

	//2”Ô–ÚˆÈ~‚Ì—v‘f‚Ì”äŠr
	while (p->next != l->tail) {
		if (p->next == n) {
			p->next = n->next;
			l->length = l->length - 1;
			return;
		}
		p = p->next;
	}
	if (p->next == n) {
		l->tail = p;
		l->length = l->length - 1;
	}
	return;
}
