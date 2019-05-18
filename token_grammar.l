/*** Definition Section that may have variables
which can be accessed inside yylex()
and main() ***/

%option noyywrap

%{
#include "heading.h"
#include "tok.h"
int yyerror(char *s);
int yylineno1 = 1;
%}

ws      [ \n\t\r]+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
num  	  {digit}+(\.{digit}+)?(E[+-I]?{digit}+)?
relop	  (<)|(<\=)|(>)|(>\=)|(\=\=)|(!\=)
addop   \+|-
mulop	  (\*)|(\/)
assign  \=
%%

boolean   { printf("boolean\n"); yylval.lexeme = new std::string(yytext); }
int       { printf("int\n"); yylval.lexeme = new std::string(yytext); }
float 	  { printf("float\n"); yylval.lexeme = new std::string(yytext); }
ws	      { printf("ws"); }
if   	    { printf("if\n"); yylval.lexeme = new std::string(yytext); }
else 	    { printf("else\n"); yylval.lexeme = new std::string(yytext); }
while 	  { printf("while\n"); yylval.lexeme = new std::string(yytext); }
{id}	    { printf("id|%s\n", yytext); yylval.lexeme = new std::string(yytext);}// return T_ID; }
{num}	    { printf("number|%s\n", yytext); yylval.double_val = atoi(yytext);}// return NUM; }
{relop}	  { printf("relop|%s\n", yytext); yylval.lexeme = new std::string(yytext); }
{addop}	  { printf("addop|%s\n", yytext); yylval.lexeme = new std::string(yytext); }
{mulop}	  { printf("mulop|%s\n", yytext); yylval.lexeme = new std::string(yytext); }
{assign}	{ printf("assign\n"); yylval.lexeme = new std::string(yytext); }
"("	      { printf("(\n"); yylval.lexeme = new std::string(yytext); }
")"	      { printf(")\n"); yylval.lexeme = new std::string(yytext); }
"{"       { printf("{\n"); yylval.lexeme = new std::string(yytext); }
"}"       { printf("}\n"); yylval.lexeme = new std::string(yytext); }
","       { printf(",\n"); yylval.lexeme = new std::string(yytext); }
";"       { printf(";\n"); yylval.lexeme = new std::string(yytext); }
[\n]		  { yylineno1++;	}
.		      { std::cerr << "SCANNER "; yyerror(""); exit(1);	}
