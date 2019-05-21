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
  struct {
    int type;
    int ival;
    float fval;
  } exp;
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
%type<exp> ARTH_FACTOR T_EXPRESSION ARTH_EXPRESSION EXPRESSION
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
    TYPE ID SEMICOLON
    {
      string str($2);
      if($1 == INT_T)
      {
        defineVar(str,INT_T);
      }
      else if ($1 == FLOAT_T)
      {
        defineVar(str,FLOAT_T);
      }
    }
;

TYPE :
    INT_WORD   { $$ = INT_T; }
  | FLOAT_WORD { $$ = FLOAT_T; }
;

ASSIGNMENT :
    ID ASSIGN EXPRESSION SEMICOLON
    {
  		string str($1);
  		if(checkId(str))
  		{
  			if($3.type == symbTab[str].second)
  			{
  				if($3.type == INT_T)
  				{
  					writeCode("istore " + to_string(symbTab[str].first));
  				}
          else if ($3.type == FLOAT_T)
  				{
  					writeCode("fstore " + to_string(symbTab[str].first));
  				}
  			}
  			else
  			{
  				yyerror("Different types in expression. Not supported yet");
  			}
  		}
      else
      {
  			string err = "identifier: " + str + " isn't declared in this scope";
  			yyerror(err.c_str());
  		}
  	}
;

EXPRESSION :
    ARTH_EXPRESSION
    {
      $$.type = $1.type;
      if($$.type == INT_T)
      {
        $$.ival = $1.ival;
        writeCode("ldc " + to_string($1.ival));
      }
      else
      {
        $$.fval = $1.fval;
        writeCode("ldc " + to_string($1.fval));
      }
    }
  // | BOOL_EXPRESSION
;

ARTH_EXPRESSION :
    ARTH_EXPRESSION ADDOP T_EXPRESSION
    {
      if($1.type == $3.type)
      {
        if($1.type == INT_T)
        {
          if($2 == '+')
          {
            $$.ival = $1.ival + $3.ival;
          }
          else if ($2 == '-')
          {
            $$.ival = $1.ival - $3.ival;
          }
        }
        else if($1.type == FLOAT_T)
        {
          if($2 == '+')
          {
            $$.fval = $1.fval + $3.fval;
          }
          else if ($2 == '-')
          {
            $$.fval = $1.fval - $3.fval;
          }
        }
      }
      else
      {
        yyerror("Different types in expression. Not supported yet");
      }
    }
  | T_EXPRESSION
    {
      $$.type = $1.type;
      if($$.type == INT_T)
      {
        $$.ival = $1.ival;
      }
      else
      {
        $$.fval = $1.fval;
      }
    }
;

T_EXPRESSION :
    T_EXPRESSION MULOP ARTH_FACTOR
    {
      if($1.type == $3.type)
      {
        if($1.type == INT_T)
        {
          if($2 == '*')
          {
            $$.ival = $1.ival * $3.ival;
          }
          else if ($2 == '/')
          {
            $$.ival = $1.ival / $3.ival;
          }
        }
        else if($1.type == FLOAT_T)
        {
          if($2 == '*')
          {
            $$.fval = $1.fval * $3.fval;
          }
          else if ($2 == '/')
          {
            $$.fval = $1.fval / $3.fval;
          }
        }
      }
      else
      {
        yyerror("Different types in expression. Not supported yet");
      }
    }
  | ARTH_FACTOR
    {
      $$.type = $1.type;
      if($$.type == INT_T)
      {
        $$.ival = $1.ival;
      }
      else
      {
        $$.fval = $1.fval;
      }
    }
;

ARTH_FACTOR :
    INTEGER_LITERAL { $$.type = INT_T; $$.ival = $1; }
  | FLOAT_LITERAL   { $$.type = FLOAT_T; $$.fval = $1; }
  | ID
  | LEFT_BRACKET ARTH_EXPRESSION RIGHT_BRACKET
    {
      $$.type = $2.type;
      if($$.type == INT_T)
      {
        $$.ival = $2.ival;
      }
      else
      {
        $$.fval = $2.fval;
      }
    }
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
