%{
  #include <stdio.h>
  #include "parse.tab.h"
%}

%option noyywrap

delim	[ \t\n]
ws	{delim}+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
float   {digit}+(\.{digit}+)
int  	{digit}+
relop	(<)|(<\=)|(>)|(>\=)|(\=\=)|(!\=)
addop   \+|-
mulop	(\*)|(\/)

%%
boolean {printf("boolean\n");}
int 	{strcpy(yylval.name,yytext); return INT;}
float 	{strcpy(yylval.name,yytext); return FLOAT;}
ws	{}
if   	{printf("if\n");}
else 	{printf("else\n");}
while 	{printf("while\n");}
{id}	{printf("id\n");strcpy(yylval.name,yytext); return ID;}
{int}	{yylval.ival = atoi(yytext); return INT;}
{float}	{ return FLOAT;}
{relop}	{printf("relop\n");}
{addop}	{return ADDOP;}
{mulop}	{return MULOP;}
\(	{printf("(\n");}
\)	{printf(")\n");}
{	{printf("{\n");}
}	{printf("}\n");}
,	{printf(",\n");}
;	{printf(";\n"); return SEMICOLON;}
%%

void yyerror(char const *s) { fprintf(stderr, "%s\n", s); }
