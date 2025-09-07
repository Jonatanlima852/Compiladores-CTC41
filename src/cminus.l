/****************************************************/
/* File: cminus.l                                   */
/* Lex specification for C-                         */
/* Project for CES41: Compiladores                  */
/****************************************************/

%option noyywrap 
/* opção noyywrap pode ser necessária para novas versões do flex
  limitação: não compila mais de um arquivo fonte de uma só vez (não precisamos disso)
  https://stackoverflow.com/questions/1480138/undefined-reference-to-yylex 
*/ 

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}
digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+
%%
"if"            {return IF;}
"then"          {return THEN;}
"else"          {return ELSE;}
"end"           {return END;}
"repeat"        {return REPEAT;}
"until"         {return UNTIL;}
"read"          {return READ;}
"write"         {return WRITE;}
"int"           {return INT;}           // JONATAN: adicionei token faltante
"void"          {return VOID;}          // JONATAN: adicionei token faltante
"return"        {return RETURN;}        // JONATAN: adicionei token faltante
"while"         {return WHILE;}         // JONATAN: adicionei token faltante
":="            {return ASSIGN;}
"=="            {return EQ;}            // JONATAN: adicionei token que faltava
"="             {return ASSIGN_SIMPLE;} // JONATAN: mudei para ASSIGN_SIMPLE
"<"             {return LT;}
"<="            {return LE;}            // JONATAN: adicionei token faltante
">"             {return GT;}            // JONATAN: adicionei token faltante
">="            {return GE;}            // JONATAN: adicionei token faltante
"!="            {return NE;}            // JONATAN: adicionei token faltante
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
"["             {return LBRACKET;}      // JONATAN: adicionei token que faltava
"]"             {return RBRACKET;}      // JONATAN: adicionei token que faltava
"{"             {return LBRACE;}        // JONATAN: corrigi pois estava dando problema
"}"             {return RBRACE;}        // JONATAN: adicionei token que faltava
";"             {return SEMI;}
","             {return COMMA;}         // JONATAN: adicionei token que faltava
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++; printLine(redundant_source);}  // JONATAN: adicionei printLine
{whitespace}    {/* skip whitespace */}
"/*"            {                       // JONATAN: corrigindo forma que são analisados os comentarios
                  char c, prev = 0;
                  while ((c = input()) != EOF) {
                    if (prev == '*' && c == '/') break;
                    if (c == '\n') { lineno++; printLine(redundant_source); }
                    prev = c;
                  }
                }
[^a-zA-Z0-9 \t\n\r{}();,=<>!+\-*/\[\]] {return ERROR;}
%%
TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = source;
    yyout = listing;
    printLine(redundant_source);    // JONATAN: adicionei para printar a linha nova
  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  if (TraceScan) {
    pc("\t%d: ",lineno);
    printToken(currentToken,tokenString);
  }
  return currentToken;
}
