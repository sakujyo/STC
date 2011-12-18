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
		default:
			break;
	}
}
void destructNode(Node *n){	free(n);}
List *newList(void)
{
	List *l;
	l = malloc(sizeof(List));
	l->length = 0;
	return l;
}
void destructList(List *l){	free(l);	/* TODO: destruct Nodes */}
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
