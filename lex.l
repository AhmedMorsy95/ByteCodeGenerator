%{
  #include <stdio.h>
  #include "parse.tab.h"
  // #include "heading.h"
  #include "tok.h"
  int yyerror(char *s);
  int yylineno1 = 1;
%}

%option noyywrap

delim	  [ \t\n]
ws	    {delim}+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
float   {digit}+(\.{digit}+)
int  	  {digit}+
relop	  "<"|"<="|">"|">="|"=="|"!="
binop   "&&"|"||"
notop   "!"
addop   "+"|"-"
mulop	  "*"|"/"|"%"
comment "//".*

%%
{ws}       {}
"System.out.println"	{ return PRINT_FUNCTION; }
"int" 	   { strcpy(yylval.name,yytext); return INT_WORD; }
"float" 	 { strcpy(yylval.name,yytext); return FLOAT_WORD; }
"boolean"  { strcpy(yylval.name,yytext); return BOOL_WORD; }
"if"   	   { return IF_WORD; }
"else"     { return ELSE_WORD; }
"while"    { printf("while\n"); }
"true"     { return TRUE; }
"false"    { return FALSE; }
{id}	     { strcpy(yylval.name,yytext); return ID; }
{int}	     { yylval.ival = atoi(yytext); return INTEGER_LITERAL; }
{float}	   { yylval.fval = atof(yytext); return FLOAT_LITERAL; }
{relop}	   { strcpy(yylval.op,yytext); return RELOP; }
{binop}	   { strcpy(yylval.op,yytext); return BINOP; }
{notop}	   { strcpy(yylval.op,yytext); return NOTOP; }
{addop}	   { strcpy(yylval.op,yytext); return ADDOP; }
{mulop}	   { strcpy(yylval.op,yytext); return MULOP; }
"="        { return ASSIGN; }
"("	       { return LEFT_BRACKET; }
")"	       { return RIGHT_BRACKET; }
"{"        { return LEFT_BRACE; }
"}"        { return RIGHT_BRACE; }
","        { printf(",\n"); }
";"        { return SEMICOLON; }
{comment}  { return COMMENT_LINE; }
%%
