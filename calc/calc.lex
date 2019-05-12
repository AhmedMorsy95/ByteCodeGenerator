/* Mini Calculator */
/* calc.lex */
%option noyywrap

%{
#include "heading.h"
#include "tok.h"
int yyerror(char *s);
int yylineno1 = 1;
%}

digit		[0-9]
int_const	{digit}+

%%

{int_const}	{ yylval.int_val = atoi(yytext); return INTEGER_LITERAL; }
"+"		{ yylval.op_val = new std::string(yytext); return PLUS; }
"*"		{ yylval.op_val = new std::string(yytext); return MULT; }

[ \t]*		{}
[\n]		{ yylineno1++;	}

.		{ std::cerr << "SCANNER "; yyerror(""); exit(1);	}
