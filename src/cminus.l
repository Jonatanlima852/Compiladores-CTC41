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
#include "parser.h"
#include "scan.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];

static void setTokenString(const char *text)
{
  size_t len = strlen(text);
  if (len > MAXTOKENLEN) len = MAXTOKENLEN;
  memcpy(tokenString, text, len);
  tokenString[len] = '\0';
}
%}
digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+
%%
"if"            {setTokenString(yytext); return IF;}
"then"          {setTokenString(yytext); return THEN;}
"else"          {setTokenString(yytext); return ELSE;}
"end"           {setTokenString(yytext); return END;}
"repeat"        {setTokenString(yytext); return REPEAT;}
"until"         {setTokenString(yytext); return UNTIL;}
"read"          {setTokenString(yytext); return READ;}
"write"         {setTokenString(yytext); return WRITE;}
"int"           {setTokenString(yytext); return INT;}
"void"          {setTokenString(yytext); return VOID;}
"return"        {setTokenString(yytext); return RETURN;}
"while"         {setTokenString(yytext); return WHILE;}
":="            {return ASSIGN;}
"=="            {return EQ;}
"="             {return ASSIGN_SIMPLE;}
"<"             {return LT;}
"<="            {return LE;}
">"             {return GT;}
">="            {return GE;}
"!="            {return NE;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
"["             {return LBRACKET;}
"]"             {return RBRACKET;}
"{"             {return LBRACE;}
"}"             {return RBRACE;}
";"             {return SEMI;}
","             {return COMMA;}
{number}        {setTokenString(yytext); return NUM;}
{identifier}    {setTokenString(yytext); 
                 if (currentFunctionName) free(currentFunctionName);
                 currentFunctionName = copyString(yytext);
                 return ID;}
{newline}       {lineno++; printLineLEX(redundant_source);}
{whitespace}    {/* skip whitespace */}
"/*"            {
                  char c, prev = 0;
                  while ((c = input()) != EOF) {
                    if (prev == '*' && c == '/') break;
                    if (c == '\n') { lineno++; printLineLEX(redundant_source); }
                    prev = c;
                  }
                }
[^a-zA-Z0-9 \t\n\r{}();,=<>!+\-*/\[\]] {setTokenString(yytext); return ERROR;}
%%
TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = source;
    yyout = listing;
    printLineLEX(redundant_source);
  }
  currentToken = yylex();
  if (TraceScan) {
    pp(LEX, "\t%d: ",lineno);
    printTokenLEX(currentToken,tokenString);
  }
  return currentToken;
}
