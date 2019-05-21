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
addop   "+"|"-"
mulop	  "*"|"/"

%%
{ws}       {}
"boolean"  { printf("boolean\n"); }
"int" 	   { strcpy(yylval.name,yytext); return INT_WORD; }
"float" 	 { strcpy(yylval.name,yytext); return FLOAT_WORD; }
"if"   	   { printf("if\n"); }
"else"     { printf("else\n"); }
"while"    { printf("while\n"); }
{id}	     { strcpy(yylval.name,yytext); return ID; }
{int}	     { yylval.ival = atoi(yytext); return INTEGER_LITERAL; }
{float}	   { yylval.fval = atof(yytext); return FLOAT_LITERAL; }
{relop}	   { printf("relop\n"); }
{addop}	   { strcpy(yylval.op,yytext); return ADDOP; }
{mulop}	   { strcpy(yylval.op,yytext); return MULOP; }
"="        { return ASSIGN; }
"("	       { return LEFT_BRACKET; }
")"	       { return RIGHT_BRACKET; }
"{"        { printf("{\n"); }
"}"        { printf("}\n"); }
","        { printf(",\n"); }
";"        { return SEMICOLON; }
%%
