/* Infix notation calculator.  */
%{
  #include <math.h>
  #include <stdio.h>
  #include "heading.h"
  int yyerror(char *s);
  int yylex(void);
%}

%union{
  int		int_val;
  double double_val;
  string*	lexeme;
}

/* Bison declarations.  */
// %define api.value.type {double}
// %token NUM
// %left '-' '+'
// %left '*' '/'
// %precedence NEG   /* negation--unary minus */
// %right '^'        /* exponentiation */

%% /* The grammar follows.  */

input:
    %empty
  | STATEMENT_LIST {printf("input -> STATEMENT_LIST");}
;

STATEMENT_LIST:
    STATEMENT                   {printf("STATEMENT_LIST -> STATEMENT");}
  | STATEMENT_LIST STATEMENT    {printf("STATEMENT_LIST -> STATEMENT_LIST STATEMENT");}
;

STATEMENT:
    DECLARATION       {printf("STATEMENT -> DECLARATION");}
  | IF                {printf("STATEMENT -> IF");}
  | WHILE             {printf("STATEMENT -> WHILE");}
  | ASSIGNMENT        {printf("STATEMENT -> ASSIGNMENT");}
;

DECLARATION:
    PRIMITIVE_TYPE "id" ';'     {printf("DECLARATION -> PRIMITIVE_TYPE id");}
;

PRIMITIVE_TYPE:
    "int"       {printf("PRIMITIVE_TYPE -> int");}
  | 'float'     {printf("PRIMITIVE_TYPE -> float");}
;

IF:
    "if" '(' EXPRESSION ')' '{' STATEMENT '}' "else" '{' STATEMENT '}'
  | "if" '(' EXPRESSION ')' '{' STATEMENT '}'
;

WHILE:
    "while" '(' EXPRESSION ')' '{' STATEMENT '}'
;

ASSIGNMENT:
    "id" "assign" EXPRESSION ';'
;

EXPRESSION:
    SIMPLE_EXPRESSION
  | SIMPLE_EXPRESSION "relop" SIMPLE_EXPRESSION
;

SIMPLE_EXPRESSION:
    TERM
  | SIGN TERM
  | SIMPLE_EXPRESSION "addop" TERM
;

TERM:
    FACTOR
  | TERM "mulop" FACTOR
;

FACTOR:
    "id"
  | "num"
  | '(' EXPRESSION ')'
;

SIGN:
    '+'
  | '-'



%%

int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c

  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int yyerror(char *s)
{
  return yyerror(string(s));
}
