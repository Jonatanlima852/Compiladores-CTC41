/****************************************************/
/* File: cminus.y                                   */
/* C- Yacc/Bison specification file                 */
/****************************************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
#include "parse.h"
#include "log.h"

#define YYSTYPE TreeNode *
static TreeNode * savedTree;
static int yylex(void);
int yyerror(char *);
extern int yychar; /* Bison global: current token when error occurs */
extern FileDestination currentState;

/* Função auxiliar para construir listas ligadas */
static TreeNode * appendToList(TreeNode * list, TreeNode * newItem) {
  if (list == NULL) return newItem;
  TreeNode * t = list;
  while (t->sibling != NULL) t = t->sibling;
  t->sibling = newItem;
  return list;
}

%}

%token IF THEN ELSE END REPEAT UNTIL READ WRITE
%token INT VOID RETURN WHILE
%token ID NUM 
%token ASSIGN ASSIGN_SIMPLE EQ LT LE GT GE NE PLUS MINUS TIMES OVER 
%token LPAREN RPAREN SEMI COMMA LBRACKET RBRACKET LBRACE RBRACE
%token ERROR

%nonassoc THEN
%nonassoc ELSE
%right ASSIGN ASSIGN_SIMPLE
%left EQ LT LE GT GE NE
%left PLUS MINUS
%left TIMES OVER

%% /* Grammar for C- */

program     : declaration-list
                 { savedTree = $1;} 
            ;

declaration-list : declaration-list declaration
                 { $$ = appendToList($1, $2); }
                 | declaration { $$ = $1; }
                 ;

declaration : var-declaration { $$ = $1; }
            | fun-declaration { $$ = $1; }
            ;

var-declaration : type-specifier ID SEMI
                 { TreeNode * typeNode = $1;
                   $$ = newDeclNode(VarDeclK);
                   $$->attr.name = copyString(tokenString);
                   $$->type = (typeNode && typeNode->attr.name && strcmp(typeNode->attr.name, "void") == 0) ? Void : Integer;
                   $$->child[0] = typeNode;
                 }
                 | type-specifier array-name LBRACKET NUM RBRACKET SEMI
                 { TreeNode * typeNode = $1;
                   $$ = newDeclNode(VarDeclK);
                   $$->attr.name = (char *)$2;
                   $$->type = (typeNode && typeNode->attr.name && strcmp(typeNode->attr.name, "void") == 0) ? Void : Integer;
                   $$->child[0] = newExpNode(ConstK);
                   $$->child[0]->attr.val = atoi(tokenString);
                   $$->child[1] = typeNode;
                 }
                 ;

array-name : ID { $$ = (TreeNode *)copyString(tokenString); }
            ;

type-specifier : INT { $$ = newExpNode(IdK); $$->attr.name = "int"; }
               | VOID { $$ = newExpNode(IdK); $$->attr.name = "void"; }
               ;

fun-declaration : type-specifier function-name LPAREN params RPAREN compound-stmt
                 { $$ = newDeclNode(FunDeclK);
                   $$->attr.name = (char *)$2;
                   $$->type = ($1 && $1->attr.name && strcmp($1->attr.name, "void") == 0) ? Void : Integer;
                   $$->child[0] = $1;
                   $$->child[1] = $4;
                   $$->child[2] = $6;
                 }
                 ;

function-name : ID { $$ = (TreeNode *)copyString(tokenString); }
               ;

params : param-list { $$ = $1; }
       | VOID { $$ = NULL; }
       | /* empty */ { $$ = NULL; }
       ;

param-list : param-list COMMA param
            { $$ = appendToList($1, $3); }
            | param { $$ = $1; }
            ;

param : type-specifier ID
       { $$ = newDeclNode(ParamK);
         $$->attr.name = copyString(tokenString);
         $$->type = ($1 && $1->attr.name && strcmp($1->attr.name, "void") == 0) ? Void : Integer;
         $$->child[0] = $1;
       }
       | type-specifier ID LBRACKET RBRACKET
       { $$ = newDeclNode(ParamArrayK);
         $$->attr.name = copyString(tokenString);
         $$->type = ($1 && $1->attr.name && strcmp($1->attr.name, "void") == 0) ? Void : Integer;
         $$->child[0] = $1;
       }
       ;

compound-stmt : LBRACE local-declarations statement-list RBRACE
               { $$ = newStmtNode(CompoundK);
                 $$->child[0] = $2;
                 $$->child[1] = $3;
               }
               ;

local-declarations : local-declarations var-declaration
                    { $$ = appendToList($1, $2); }
                    | /* empty */ { $$ = NULL; }
                    ;

statement-list : statement-list statement
                { $$ = appendToList($1, $2); }
                | /* empty */ { $$ = NULL; }
                ;

statement : expression-stmt { $$ = $1; }
          | compound-stmt { $$ = $1; }
          | selection-stmt { $$ = $1; }
          | iteration-stmt { $$ = $1; }
          | return-stmt { $$ = $1; }
          ;

expression-stmt : expression SEMI
                 { $$ = $1; }
                 | SEMI { $$ = NULL; }
                 ;

selection-stmt : IF LPAREN expression RPAREN statement
                { $$ = newStmtNode(IfK);
                  $$->child[0] = $3;
                  $$->child[1] = $5;
                }
                | IF LPAREN expression RPAREN statement ELSE statement
                { $$ = newStmtNode(IfK);
                  $$->child[0] = $3;
                  $$->child[1] = $5;
                  $$->child[2] = $7;
                }
                ;

iteration-stmt : WHILE LPAREN expression RPAREN statement
                { $$ = newStmtNode(WhileK);
                  $$->child[0] = $3;
                  $$->child[1] = $5;
                }
                ;

return-stmt : RETURN SEMI
             { $$ = newStmtNode(ReturnK); }
             | RETURN expression SEMI
             { $$ = newStmtNode(ReturnK);
               $$->child[0] = $2;
             }
             ;

expression : var ASSIGN_SIMPLE expression
            { $$ = newStmtNode(AssignK);
              $$->child[0] = $1;
              $$->child[1] = $3;
              $$->attr.name = $1->attr.name;
            }
            | simple-expression { $$ = $1; }
            ;

var : ID { $$ = newExpNode(IdK);
           $$->attr.name = copyString(tokenString);
         }
         | array-access LBRACKET expression RBRACKET
         { $$ = newExpNode(IdK);
           $$->attr.name = (char *)$1;
           $$->child[0] = $3;
         }
         ;

array-access : ID { $$ = (TreeNode *)copyString(tokenString); }
              ;

simple-expression : additive-expression LT additive-expression
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = LT;
                    }
                    | additive-expression LE additive-expression
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = LE;
                    }
                    | additive-expression GT additive-expression
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = GT;
                    }
                    | additive-expression GE additive-expression
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = GE;
                    }
                    | additive-expression EQ additive-expression
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = EQ;
                    }
                    | additive-expression NE additive-expression
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = NE;
                    }
                    | additive-expression { $$ = $1; }
                    ;

additive-expression : additive-expression PLUS term
                     { $$ = newExpNode(OpK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                       $$->attr.op = PLUS;
                     }
                     | additive-expression MINUS term
                     { $$ = newExpNode(OpK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                       $$->attr.op = MINUS;
                     }
                     | term { $$ = $1; }
                     ;

term : term TIMES factor
      { $$ = newExpNode(OpK);
        $$->child[0] = $1;
        $$->child[1] = $3;
        $$->attr.op = TIMES;
      }
      | term OVER factor
      { $$ = newExpNode(OpK);
        $$->child[0] = $1;
        $$->child[1] = $3;
        $$->attr.op = OVER;
      }
      | factor { $$ = $1; }
      ;

factor : LPAREN expression RPAREN
        { $$ = $2; }
        | var { $$ = $1; }
        | call { $$ = $1; }
        | NUM
        { $$ = newExpNode(ConstK);
          $$->attr.val = atoi(tokenString);
        }
        | MINUS factor
        { $$ = newExpNode(OpK);
          $$->attr.op = MINUS;
          $$->child[0] = newExpNode(ConstK);
          $$->child[0]->attr.val = 0;
          $$->child[1] = $2;
        }
        ;

call : function-call LPAREN args RPAREN
      { $$ = newExpNode(CallK);
        $$->attr.name = (char *)$1;
        $$->child[0] = $3;
      }
      ;

function-call : ID { $$ = (TreeNode *)copyString(tokenString); }
               ;

args : arg-list { $$ = $1; }
     | /* empty */ { $$ = NULL; }
     ;

arg-list : arg-list COMMA expression
          { $$ = appendToList($1, $3); }
          | expression { $$ = $1; }
          ;

%%

int yyerror(char * message)
{ 
  FileDestination previousState = currentState;
  if (yychar == ERROR) {
    currentState = ER_;
    printToken(yychar, tokenString);
    currentState = previousState;
  }

  pp(LER, "Syntax error at line %d: %s\n", lineno, message);
  pp(LER, "Current token: ");
  if (yychar >= 0) {
    if (yychar == ERROR) {
      currentState = ER_;
      printToken(yychar, tokenString);
      currentState = previousState;
    } else {
      pp(ER_, "\n");
    }
    printTokenLEX(yychar, tokenString);
  } else {
    pp(ER_, "\n");
    pp(LEX, "\n");
  }
  Error = TRUE;
  return 0;
}

/* yylex calls getToken for compatibility */
int yylex(void)
{ return getToken(); }

TreeNode * parse(void)
{ yyparse();
  return savedTree;
}
