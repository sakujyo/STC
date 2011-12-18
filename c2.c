#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "myList.h"
#include "myLib.h"

int main(int argc, char *argv[])
{
	List *l1, *l2;
	Node *n1, *n2, *n3, *n4, *n5, *n6, *n7;
	l1 = newList();
	//ListPrint(l1);

	n1 = newNodeMul();
	ListAdd(l1, n1);
	n2 = newNodeInt(8);
	ListAdd(l1, n2);
	n3 = newNodeInt(9);
	ListAdd(l1, n3);
	ListPrint(l1);

	l2 = newList();
	n4 = newNodeFunc();
	ListAdd(l2, n4);
	n5 = newNodeString("putchar");
	ListAdd(l2, n5);
	//n6 = newNodeInt(1);
	n7 = newNodeList(l1);
	ListAdd(l2, n7);
	ListPrint(l2);



	return 0;
}
