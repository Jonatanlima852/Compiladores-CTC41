/****************************************************/
/* File: util.c                                     */
/* Utility function implementation                  */
/* for the TINY compiler                            */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

#include "globals.h"
#include "util.h"
#include "parser.h"
#include "log.h"



void printLine(FILE *redundant_source) { 
  char line[1024]; 
  char *ret = fgets(line, 1024, redundant_source); 
  if (ret) { 
      pc("%d: %-1s", lineno, line); 
      if (feof(redundant_source)) 
          pc("\n"); 
  } 
}

void printLineLEX(FILE *redundant_source) { 
  char line[1024]; 
  char *ret = fgets(line, 1024, redundant_source); 
  if (ret) { 
      pp(LEX, "%d: %-1s", lineno, line); 
      if (feof(redundant_source)) 
          pp(LEX, "\n"); 
  } 
}


/* Função auxiliar para imprimir tokens */
static void printTokenInternal(TokenType token, const char* tokenString, int useLEX) {
  switch (token) {
    case IF:
    case THEN:
    case ELSE:
    case END:
    case REPEAT:
    case UNTIL:
    case READ:
    case WRITE:
    case INT:
    case VOID:
    case RETURN:
    case WHILE:
      if (useLEX) {
        pp(LEX, "reserved word: %s\n", tokenString);
      } else {
        pc("reserved word: %s\n", tokenString);
      }
      break;
    case ASSIGN: 
      if (useLEX) pp(LEX, ":=\n"); else pc(":=\n"); 
      break;
    case ASSIGN_SIMPLE: 
      if (useLEX) pp(LEX, "=\n"); else pc("=\n"); 
      break;
    case LT: 
      if (useLEX) pp(LEX, "<\n"); else pc("<\n"); 
      break;
    case LE: 
      if (useLEX) pp(LEX, "<=\n"); else pc("<=\n"); 
      break;
    case GT: 
      if (useLEX) pp(LEX, ">\n"); else pc(">\n"); 
      break;
    case GE: 
      if (useLEX) pp(LEX, ">=\n"); else pc(">=\n"); 
      break;
    case EQ: 
      if (useLEX) pp(LEX, "==\n"); else pc("==\n"); 
      break;
    case NE: 
      if (useLEX) pp(LEX, "!=\n"); else pc("!=\n"); 
      break;
    case LPAREN: 
      if (useLEX) pp(LEX, "(\n"); else pc("(\n"); 
      break;
    case RPAREN: 
      if (useLEX) pp(LEX, ")\n"); else pc(")\n"); 
      break;
    case LBRACKET: 
      if (useLEX) pp(LEX, "[\n"); else pc("[\n"); 
      break;
    case RBRACKET: 
      if (useLEX) pp(LEX, "]\n"); else pc("]\n"); 
      break;
    case LBRACE: 
      if (useLEX) pp(LEX, "{\n"); else pc("{\n"); 
      break;
    case RBRACE: 
      if (useLEX) pp(LEX, "}\n"); else pc("}\n"); 
      break;
    case SEMI: 
      if (useLEX) pp(LEX, ";\n"); else pc(";\n"); 
      break;
    case COMMA: 
      if (useLEX) pp(LEX, ",\n"); else pc(",\n"); 
      break;
    case PLUS: 
      if (useLEX) pp(LEX, "+\n"); else pc("+\n"); 
      break;
    case MINUS: 
      if (useLEX) pp(LEX, "-\n"); else pc("-\n"); 
      break;
    case TIMES: 
      if (useLEX) pp(LEX, "*\n"); else pc("*\n"); 
      break;
    case OVER: 
      if (useLEX) pp(LEX, "/\n"); else pc("/\n"); 
      break;
    case ENDFILE: 
      if (useLEX) pp(LEX, "EOF\n"); else pc("EOF\n"); 
      break;
    case NUM:
      if (useLEX) {
        pp(LEX, "NUM, val= %s\n", tokenString);
      } else {
        pc("NUM, val= %s\n", tokenString);
      }
      break;
    case ID:
      if (useLEX) {
        pp(LEX, "ID, name= %s\n", tokenString);
      } else {
        pc("ID, name= %s\n", tokenString);
      }
      break;
    case ERROR:
      if (useLEX) {
        pp(LEX, "ERROR: %s\n", tokenString);
      } else {
        pce("ERROR: %s\n", tokenString);
      }
      break;
    default:
      if (useLEX) {
        pp(LEX, "Unknown token: %d\n", token);
      } else {
        pce("Unknown token: %d\n", token);
      }
  }
}

/* Procedure printToken prints a token and its lexeme to the listing file */
void printToken(TokenType token, const char* tokenString) {
  printTokenInternal(token, tokenString, 0);
}

/* Procedure printTokenLEX prints a token and its lexeme only to the LEX file */
void printTokenLEX(TokenType token, const char* tokenString) {
  printTokenInternal(token, tokenString, 1);
}

/* Function newStmtNode creates a new statement
 * node for syntax tree construction
 */
TreeNode * newStmtNode(StmtKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
  int i;
  if (t==NULL)
    pce("Out of memory error at line %d\n",lineno);
  else {
    for (i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
    t->sibling = NULL;
    t->nodekind = StmtK;
    t->kind.stmt = kind;
    t->lineno = lineno;
    t->type = Void;
  }
  return t;
}

/* Function newExpNode creates a new expression
 * node for syntax tree construction
 */
TreeNode * newExpNode(ExpKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
  int i;
  if (t==NULL)
    pce("Out of memory error at line %d\n",lineno);
  else {
    for (i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
    t->sibling = NULL;
    t->nodekind = ExpK;
    t->kind.exp = kind;
    t->lineno = lineno;
    t->type = Void;
  }
  return t;
}

/* Function newDeclNode creates a new declaration
 * node for syntax tree construction
 */
TreeNode * newDeclNode(DeclKind kind)
{ TreeNode * t = (TreeNode *) malloc(sizeof(TreeNode));
  int i;
  if (t==NULL)
    pce("Out of memory error at line %d\n",lineno);
  else {
    for (i=0;i<MAXCHILDREN;i++) t->child[i] = NULL;
    t->sibling = NULL;
    t->nodekind = DeclK;
    t->kind.decl = kind;
    t->lineno = lineno;
    t->type = Void;
  }
  return t;
}

/* Function copyString allocates and makes a new
 * copy of an existing string
 */
char * copyString(char * s)
{ int n;
  char * t;
  if (s==NULL) return NULL;
  n = strlen(s)+1;
  t = malloc(n);
  if (t==NULL)
    pce("Out of memory error at line %d\n",lineno);
  else strcpy(t,s);
  return t;
}

/* Variable indentno is used by printTree to
 * store current number of spaces to indent
 */
static int indentno = 0;

/* macros to increase/decrease indentation */
#define INDENT indentno+=4
#define UNINDENT do { indentno-=4; if (indentno < 0) indentno = 0; } while(0)

/* printSpaces indents by printing spaces */
static void printSpaces(void)
{ int i;
  if (indentno < 0) indentno = 0;
  for (i=0;i<indentno;i++)
    pc(" ");
}

static const char *resolveTypeName(const TreeNode *typeNode, ExpType fallback)
{
  if (typeNode && typeNode->nodekind == ExpK && typeNode->kind.exp == IdK && typeNode->attr.name != NULL) {
    return typeNode->attr.name;
  }
  switch (fallback) {
    case Void: return "void";
    case Boolean: return "bool";
    case Integer:
    default: return "int";
  }
}

static void printDeclNode(TreeNode * tree)
{
  switch (tree->kind.decl) {
    case VarDeclK: {
      TreeNode *sizeNode = NULL;
      TreeNode *typeNode = NULL;
      if (tree->child[0] && tree->child[0]->nodekind == ExpK && tree->child[0]->kind.exp == ConstK) {
        sizeNode = tree->child[0];
        typeNode = tree->child[1];
      } else {
        typeNode = tree->child[0];
      }
      const char *typeName = resolveTypeName(typeNode, tree->type);
      printSpaces();
      if (sizeNode) {
        pc("Declare %s array: %s\n", typeName, tree->attr.name);
        INDENT;
        printTree(sizeNode);
        UNINDENT;
      } else if (strcmp(typeName, "void") == 0) {
        pc("Declare void var: %s\n", tree->attr.name);
      } else {
        pc("Declare %s var: %s\n", typeName, tree->attr.name);
      }
      break;
    }
    case FunDeclK: {
      const char *retType = resolveTypeName(tree->child[0], tree->type);
      printSpaces();
      pc("Declare function (return type \"%s\"): %s\n", retType, tree->attr.name);
      INDENT;
      if (tree->child[1]) {
        printTree(tree->child[1]);
      }
      if (tree->child[2]) {
        printTree(tree->child[2]);
      }
      UNINDENT;
      break;
    }
    case ParamK: {
      const char *typeName = resolveTypeName(tree->child[0], tree->type);
      printSpaces();
      pc("Function param (%s var): %s\n", typeName, tree->attr.name);
      break;
    }
    case ParamArrayK: {
      const char *typeName = resolveTypeName(tree->child[0], tree->type);
      printSpaces();
      pc("Function param (%s array): %s\n", typeName, tree->attr.name);
      break;
    }
    default:
      pce("Unknown DeclNode kind\n");
      break;
  }
}

static void printStmtNode(TreeNode * tree)
{
  switch (tree->kind.stmt) {
    case IfK:
      printSpaces();
      pc("Conditional selection\n");
      INDENT;
      if (tree->child[0]) printTree(tree->child[0]);
      if (tree->child[1]) printTree(tree->child[1]);
      if (tree->child[2]) printTree(tree->child[2]);
      UNINDENT;
      break;
    case RepeatK:
      printSpaces();
      pc("Repeat\n");
      INDENT;
      if (tree->child[0]) printTree(tree->child[0]);
      UNINDENT;
      break;
    case AssignK: {
      TreeNode *target = tree->child[0];
      int isArray = target && target->child[0] != NULL;
      printSpaces();
      pc("Assign to %s: %s\n", isArray ? "array" : "var", tree->attr.name);
      INDENT;
      if (isArray && target->child[0]) {
        printTree(target->child[0]);
      }
      if (tree->child[1]) {
        printTree(tree->child[1]);
      }
      UNINDENT;
      break;
    }
    case ReadK:
      printSpaces();
      pc("Read: %s\n", tree->attr.name);
      break;
    case WriteK:
      printSpaces();
      pc("Write\n");
      if (tree->child[0]) {
        INDENT;
        printTree(tree->child[0]);
        UNINDENT;
      }
      break;
    case WhileK:
      printSpaces();
      pc("Iteration (loop)\n");
      INDENT;
      if (tree->child[0]) printTree(tree->child[0]);
      if (tree->child[1]) printTree(tree->child[1]);
      UNINDENT;
      break;
    case ReturnK:
      printSpaces();
      pc("Return\n");
      if (tree->child[0]) {
        INDENT;
        printTree(tree->child[0]);
        UNINDENT;
      }
      break;
    case CompoundK:
      if (tree->child[0]) printTree(tree->child[0]);
      if (tree->child[1]) printTree(tree->child[1]);
      break;
    default:
      pce("Unknown StmtNode kind\n");
      break;
  }
}

static void printExpNode(TreeNode * tree)
{
  switch (tree->kind.exp) {
    case OpK:
      printSpaces();
      pc("Op: ");
      printToken(tree->attr.op,"\0");
      INDENT;
      if (tree->child[0]) printTree(tree->child[0]);
      if (tree->child[1]) printTree(tree->child[1]);
      UNINDENT;
      break;
    case ConstK:
      printSpaces();
      pc("Const: %d\n",tree->attr.val);
      break;
    case IdK:
      printSpaces();
      pc("Id: %s\n",tree->attr.name);
      if (tree->child[0]) {
        INDENT;
        printTree(tree->child[0]);
        UNINDENT;
      }
      break;
    case CallK:
      printSpaces();
      pc("Function call: %s\n",tree->attr.name);
      if (tree->child[0]) {
        INDENT;
        printTree(tree->child[0]);
        UNINDENT;
      }
      break;
    default:
      pce("Unknown ExpNode kind\n");
      break;
  }
}

/* procedure printTree prints a syntax tree to the 
 * listing file using indentation to indicate subtrees
 */
void printTree( TreeNode * tree )
{
  if (tree == NULL) return;
  while (tree != NULL) {
    switch (tree->nodekind) {
      case StmtK:
        printStmtNode(tree);
        break;
      case ExpK:
        printExpNode(tree);
        break;
      case DeclK:
        printDeclNode(tree);
        break;
      default:
        pce("Unknown node kind\n");
        break;
    }
    tree = tree->sibling;
  }
}
