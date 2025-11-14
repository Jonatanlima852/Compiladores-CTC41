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

%% /* Gramática para C- */

programa     : lista_declaracoes
                 { savedTree = $1;} 
            ;

lista_declaracoes : lista_declaracoes declaracao
                 { $$ = appendToList($1, $2); }
                 | declaracao { $$ = $1; }
                 ;

declaracao : var_declaracao { $$ = $1; }
            | fun_declaracao { $$ = $1; }
            ;

var_declaracao : tipo_especificador ID SEMI
                 { TreeNode * typeNode = $1;
                   $$ = newDeclNode(VarDeclK);
                   $$->attr.name = copyString(tokenString);
                   $$->type = (typeNode && typeNode->attr.name && strcmp(typeNode->attr.name, "void") == 0) ? Void : Integer;
                   $$->child[0] = typeNode;
                 }
                 | tipo_especificador nome_identificador LBRACKET NUM RBRACKET SEMI
                 { TreeNode * typeNode = $1;
                   $$ = newDeclNode(VarDeclK);
                   $$->attr.name = (char *)$2;
                   $$->type = (typeNode && typeNode->attr.name && strcmp(typeNode->attr.name, "void") == 0) ? Void : Integer;
                   $$->child[0] = newExpNode(ConstK);
                   $$->child[0]->attr.val = atoi(tokenString);
                   $$->child[1] = typeNode;
                 }
                 ;

nome_identificador : ID { $$ = (TreeNode *)copyString(tokenString); }
                   ;

tipo_especificador : INT { $$ = newExpNode(IdK); $$->attr.name = "int"; }
               | VOID { $$ = newExpNode(IdK); $$->attr.name = "void"; }
               ;

fun_declaracao : tipo_especificador nome_identificador LPAREN parametros RPAREN composto_decl
                 { $$ = newDeclNode(FunDeclK);
                   $$->attr.name = (char *)$2;
                   $$->type = ($1 && $1->attr.name && strcmp($1->attr.name, "void") == 0) ? Void : Integer;
                   $$->child[0] = $1;
                   $$->child[1] = $4;
                   $$->child[2] = $6;
                 }
                 ;

parametros : lista_parametros { $$ = $1; }
           | VOID { $$ = NULL; }
           ;

lista_parametros : lista_parametros COMMA parametro
            { $$ = appendToList($1, $3); }
            | parametro { $$ = $1; }
            ;

parametro : tipo_especificador ID
       { $$ = newDeclNode(ParamK);
         $$->attr.name = copyString(tokenString);
         $$->type = ($1 && $1->attr.name && strcmp($1->attr.name, "void") == 0) ? Void : Integer;
         $$->child[0] = $1;
       }
       | tipo_especificador ID LBRACKET RBRACKET
       { $$ = newDeclNode(ParamArrayK);
         $$->attr.name = copyString(tokenString);
         $$->type = ($1 && $1->attr.name && strcmp($1->attr.name, "void") == 0) ? Void : Integer;
         $$->child[0] = $1;
       }
       ;

composto_decl : LBRACE local_declaracoes lista_comandos RBRACE
               { $$ = newStmtNode(CompoundK);
                 $$->child[0] = $2;
                 $$->child[1] = $3;
               }
               ;

local_declaracoes : local_declaracoes var_declaracao
                    { $$ = appendToList($1, $2); }
                    | /* empty */ { $$ = NULL; }
                    ;

lista_comandos : lista_comandos comando
                { $$ = appendToList($1, $2); }
                | /* empty */ { $$ = NULL; }
                ;

comando : expressao_decl { $$ = $1; }
          | composto_decl { $$ = $1; }
          | selecao_decl { $$ = $1; }
          | iteracao_decl { $$ = $1; }
          | retorno_decl { $$ = $1; }
          | var_declaracao { $$ = $1; }
          ;

expressao_decl : expressao SEMI
                 { $$ = $1; }
                 | SEMI { $$ = NULL; }
                 ;

selecao_decl : IF LPAREN expressao RPAREN comando
                { $$ = newStmtNode(IfK);
                  $$->child[0] = $3;
                  $$->child[1] = $5;
                }
                | IF LPAREN expressao RPAREN comando ELSE comando
                { $$ = newStmtNode(IfK);
                  $$->child[0] = $3;
                  $$->child[1] = $5;
                  $$->child[2] = $7;
                }
                ;

iteracao_decl : WHILE LPAREN expressao RPAREN comando
                { $$ = newStmtNode(WhileK);
                  $$->child[0] = $3;
                  $$->child[1] = $5;
                }
                ;

retorno_decl : RETURN SEMI
             { $$ = newStmtNode(ReturnK); }
             | RETURN expressao SEMI
             { $$ = newStmtNode(ReturnK);
               $$->child[0] = $2;
             }
             ;

expressao : variavel ASSIGN_SIMPLE expressao
            { $$ = newStmtNode(AssignK);
              $$->child[0] = $1;
              $$->child[1] = $3;
              $$->attr.name = $1->attr.name;
            }
            | simples_expressao { $$ = $1; }
            ;

variavel : nome_identificador
         { $$ = newExpNode(IdK);
           $$->attr.name = (char *)$1;
         }
         | nome_identificador LBRACKET expressao RBRACKET
         { $$ = newExpNode(IdK);
           $$->attr.name = (char *)$1;
           $$->child[0] = $3;
         }
         ;

simples_expressao : soma_expressao LT soma_expressao
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = LT;
                    }
                    | soma_expressao LE soma_expressao
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = LE;
                    }
                    | soma_expressao GT soma_expressao
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = GT;
                    }
                    | soma_expressao GE soma_expressao
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = GE;
                    }
                    | soma_expressao EQ soma_expressao
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = EQ;
                    }
                    | soma_expressao NE soma_expressao
                    { $$ = newExpNode(OpK);
                      $$->child[0] = $1;
                      $$->child[1] = $3;
                      $$->attr.op = NE;
                    }
                    | soma_expressao { $$ = $1; }
                    ;

soma_expressao : soma_expressao PLUS termo
                     { $$ = newExpNode(OpK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                       $$->attr.op = PLUS;
                     }
                     | soma_expressao MINUS termo
                     { $$ = newExpNode(OpK);
                       $$->child[0] = $1;
                       $$->child[1] = $3;
                       $$->attr.op = MINUS;
                     }
                     | termo { $$ = $1; }
                     ;

termo : termo TIMES fator
      { $$ = newExpNode(OpK);
        $$->child[0] = $1;
        $$->child[1] = $3;
        $$->attr.op = TIMES;
      }
      | termo OVER fator
      { $$ = newExpNode(OpK);
        $$->child[0] = $1;
        $$->child[1] = $3;
        $$->attr.op = OVER;
      }
      | fator { $$ = $1; }
      ;

fator : LPAREN expressao RPAREN
        { $$ = $2; }
        | variavel { $$ = $1; }
        | ativacao { $$ = $1; }
        | NUM
        { $$ = newExpNode(ConstK);
          $$->attr.val = atoi(tokenString);
        }
        | MINUS fator
        { $$ = newExpNode(OpK);
          $$->attr.op = MINUS;
          $$->child[0] = newExpNode(ConstK);
          $$->child[0]->attr.val = 0;
          $$->child[1] = $2;
        }
        ;

ativacao : nome_identificador LPAREN argumentos RPAREN
      { $$ = newExpNode(CallK);
        $$->attr.name = (char *)$1;
        $$->child[0] = $3;
      }
      ;

argumentos : lista_argumentos { $$ = $1; }
     | /* empty */ { $$ = NULL; }
     ;

lista_argumentos : lista_argumentos COMMA expressao
          { $$ = appendToList($1, $3); }
          | expressao { $$ = $1; }
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
