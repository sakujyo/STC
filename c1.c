#include <stdlib.h>
#include <stdio.h>
#include <string.h>

enum NodeType {
	INT,
	DOUBLE,
	STRING
};

struct _Node {
	enum NodeType type;
	void *val;
	struct _Node *next;
};
typedef struct _Node Node;

struct _List {
	int length;
	Node *head;
	Node *tail;
};
typedef struct _List List;
/*Node *newNode(void)
{
	Node *n;
	n = malloc(sizeof(Node));
	return n;
}*/
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
int main(int argc, char *argv[])
{
	List *l1;
	Node *n1, *n2, *n3;
	l1 = newList();
	ListPrint(l1);

	n1 = newNodeInt(1);
	ListAdd(l1, n1);
	n2 = newNodeDouble(2.0);
	ListAdd(l1, n2);
	n3 = newNodeString("abc");
	ListAdd(l1, n3);

	ListPrint(l1);
	return 0;
}
