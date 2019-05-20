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
}

%token<name> INT_WORD
%token<name> FLOAT_WORD
%token<name> BOOL_WORD
%token<name> VOID_WORD
%token<name> ERROR_WORD
%token<name> ID
%token<ival> INTEGER_LITERAL
%token<fval> FLOAT_LITERAL
%token ADDOP MULOP SEMICOLON

%type<name> primitive_type

%start input

%%

input :
    %empty
  | {	generateHeader();	} STATEMENT_LIST { generateFooter(); printCode(); }
;

STATEMENT_LIST :
    statement
  | STATEMENT_LIST statement
;

statement :
    declaration { printf("statement\n"); }
;

declaration :
    primitive_type ID SEMICOLON { printf("declaration %s\n",$2); }
;

primitive_type :
    INT_WORD   { printf("type %s\n",$$); }
  | FLOAT_WORD { printf("type %s\n",$$); }
;

// assignment : ID "=" expression SEMICOLON
// expression : simple_expression
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
