%{
    #include <stdio.h>
    #include "heading.h"
    int yyerror(char *s);
    int yylex(void);
%}

%union {
	int ival;
	float fval;
  char name[20];
}

%token<name> INT
%token<name> FLOAT
%token<name> ID
%token<ival> INTEGER_LITERAL
%token<fval> FLOAT_LITERAL
%token ADDOP MULOP SEMICOLON

%type<name> primitive_type

%start method_body

%%

method_body :
    statement_list
;

statement_list :
    statement
  | statement_list statement
;

statement :
    declaration { printf("statement\n"); }
;

declaration :
    primitive_type ID SEMICOLON { printf("declaration %s\n",$2); }
;

primitive_type :
    INT   { printf("type %s\n",$$); }
  | FLOAT { printf("type %s\n",$$); }
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
