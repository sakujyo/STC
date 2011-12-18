#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "myList.h"

int main(int argc, char *argv[])
{
	List *l1, *l2;
	Node *n1, *n2, *n3, *n4;
	l1 = newList();
	ListPrint(l1);

	n1 = newNodeInt(1);
	ListAdd(l1, n1);
	n2 = newNodeDouble(2.0);
	ListAdd(l1, n2);
	n3 = newNodeString("abc");
	ListAdd(l1, n3);
	ListPrint(l1);

	l2 = newList();
	ListAdd(l2, n2);
	ListPrint(l2);
	n4 = newNodeList(l2);
	ListAdd(l1, n4);
	ListPrint(l1);

	ListRemove(l1, n4);
	ListPrint(l1);
	ListRemove(l1, n3);
	ListPrint(l1);
	ListRemove(l1, n3);
	ListPrint(l1);
	ListRemove(l1, n2);
	ListPrint(l1);
	ListRemove(l1, n1);
	ListPrint(l1);
	ListRemove(l1, n1);
	ListPrint(l1);
	return 0;
}
