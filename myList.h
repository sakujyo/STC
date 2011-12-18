enum NodeType {
	ADD,		// +
	MUL,		// *
	FUNCCALL,
	ASSIGN,		// =
	VAR,
	INT,
	DOUBLE,
	STRING,
	LIST
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

Node *newNodeInt(int val);
Node *newNodeDouble(double val);
Node *newNodeString(char *s);
Node *newNodeList(List *s);
Node *newNodeMul(void);
Node *newNodeFunc(void);
void NodePrint(Node *n);
void destructNode(Node *n);
List *newList(void);
void destructList(List *l);
void ListAdd(List *l, Node *n);
void ListPrint(List *l);
void ListRemove(List *l, Node *n);
