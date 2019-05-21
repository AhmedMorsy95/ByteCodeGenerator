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
  char op[2];
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
%token SEMICOLON ASSIGN LEFT_BRACKET RIGHT_BRACKET PRINT_FUNCTION

%type<type> TYPE
%type<type> ARTH_FACTOR T_EXPRESSION ARTH_EXPRESSION EXPRESSION
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
  | PRINT
;

PRINT :
    PRINT_FUNCTION LEFT_BRACKET EXPRESSION RIGHT_BRACKET SEMICOLON
    {
      if($3 == INT_T)
		  {
  			writeCode("istore " + to_string(symbTab["1syso_int_var"].first));
  			writeCode("getstatic      java/lang/System/out Ljava/io/PrintStream;");
  			writeCode("iload " + to_string(symbTab["1syso_int_var"].first ));
  			writeCode("invokevirtual java/io/PrintStream/println(I)V");
  		}
      else if ($3 == FLOAT_T)
  		{
  			writeCode("fstore " + to_string(symbTab["1syso_float_var"].first));
  			writeCode("getstatic      java/lang/System/out Ljava/io/PrintStream;");
  			writeCode("fload " + to_string(symbTab["1syso_float_var"].first ));
  			writeCode("invokevirtual java/io/PrintStream/println(F)V");
  		}
    }

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
  			if($3 == symbTab[str].second)
  			{
  				if($3 == INT_T)
  				{
  					writeCode("istore " + to_string(symbTab[str].first));
  				}
          else if ($3 == FLOAT_T)
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
    ARTH_EXPRESSION { $$ = $1; }
  // | BOOL_EXPRESSION
;

ARTH_EXPRESSION :
    ARTH_EXPRESSION ADDOP T_EXPRESSION { arithCast($1, $3, string($2)); }
  | T_EXPRESSION { $$ = $1; }
;

T_EXPRESSION :
    T_EXPRESSION MULOP ARTH_FACTOR { arithCast($1, $3, string($2)); }
  | ARTH_FACTOR { $$ = $1; }
;

ARTH_FACTOR :
    INTEGER_LITERAL { $$ = INT_T; writeCode("ldc " + to_string($1)); }
  | FLOAT_LITERAL   { $$ = FLOAT_T; writeCode("ldc "+to_string($1)); }
  | ID
    {
      string str($1);
      if(checkId(str))
      {
        $$ = symbTab[str].second;
        if($$ == INT_T)
        {
          writeCode("iload " + to_string(symbTab[str].first));
        }
        else if ($$ == FLOAT_T)
        {
          writeCode("fload " + to_string(symbTab[str].first));
        }
      }
      else
      {
        string err = "Identifier: " + str + " has not been declared";
        yyerror(err.c_str());
        $$ = ERROR_T;
      }
    }
  | LEFT_BRACKET ARTH_EXPRESSION RIGHT_BRACKET { $$ = $2; }
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
