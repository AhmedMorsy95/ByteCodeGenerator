%{
    #include <stdio.h>
    #include <iostream>
    #include "heading.h"

    using namespace std;

    int yyerror(char *s);
    int yylex(void);
%}

%union {
	int ival;
	float fval;
  char name[20];
  int type;
  char op;
}

%token<name> INT_WORD
%token<name> FLOAT_WORD
%token<name> BOOL_WORD
%token<name> VOID_WORD
%token<name> ERROR_WORD
%token<name> ID
%token<ival> INTEGER_LITERAL
%token<fval> FLOAT_LITERAL
%token<op> ADDOP MULOP
%token SEMICOLON ASSIGN LEFT_BRACKET RIGHT_BRACKET

%type<type> TYPE

%start input

%%

input :
    %empty
  | {	generateHeader();	} STATEMENT_LIST { generateFooter(); printCode(); }
;

STATEMENT_LIST :
    STATEMENT
  | STATEMENT_LIST STATEMENT
;

STATEMENT :
    DECLARATION
  | ASSIGNMENT
;

DECLARATION :
    TYPE ID SEMICOLON { string str($2); if($1 == INT_T) {defineVar(str,INT_T);} else if ($1 == FLOAT_T) {defineVar(str,FLOAT_T);} }
;

TYPE :
    INT_WORD   { $$ = INT_T; }
  | FLOAT_WORD { $$ = FLOAT_T; }
;

ASSIGNMENT :
    ID ASSIGN EXPRESSION SEMICOLON
;

EXPRESSION :
    EXPRESSION ADDOP T_EXPRESSION
  | T_EXPRESSION
;

T_EXPRESSION :
    T_EXPRESSION MULOP FACTOR
  | FACTOR
;

FACTOR :
    INTEGER_LITERAL
  | FLOAT_LITERAL
  | ID
  | LEFT_BRACKET EXPRESSION RIGHT_BRACKET
;
%%


int yyerror(string s)
{
  extern char *yytext;	// defined and maintained in lex.c
  extern int yylineno;	// defined and maintained in lex.c

  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int yyerror(char *s)
{
  return yyerror(string(s));
}
