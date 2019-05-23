%{
    #include <stdio.h>
    #include <iostream>
    #include <vector>
    #include "heading.h"

    using namespace std;

    int yyerror(char *s);
    int yylex(void);
    bool assign_flag = false;
%}

%code requires {
	#include <vector>
	using namespace std;
}

%union {
	int ival;
	float fval;
  char name[20];
  int type;
  char op[2];
  struct {
		vector<int> *trueList, *falseList;
	} bexpr;
  struct {
		vector<int> *nextList;
	} stmt;
}

%token<name> INT_WORD FLOAT_WORD BOOL_WORD VOID_WORD ERROR_WORD ID
%token<ival> INTEGER_LITERAL
%token<fval> FLOAT_LITERAL
%token<op> ADDOP MULOP RELOP BINOP NOTOP
%token SEMICOLON ASSIGN LEFT_BRACKET RIGHT_BRACKET PRINT_FUNCTION COMMENT_LINE TRUE FALSE LEFT_BRACE RIGHT_BRACE IF_WORD ELSE_WORD

%type<ival> marker goto
%type<type> TYPE
%type<stmt> IF STATEMENT STATEMENT_LIST
%type<type> ARTH_FACTOR T_EXPRESSION ARTH_EXPRESSION EXPRESSION
%type<bexpr> BOOL_FACTOR BOOL_T_EXPRESSION BOOL_EXPRESSION

%start input

%%

input :
    %empty
  | {	generateHeader();	} STATEMENT_LIST { generateFooter(); printCode(); cout << "Done" << endl; }
;

STATEMENT_LIST :
    STATEMENT
  | STATEMENT_LIST marker STATEMENT
    {
  		backpatch($1.nextList,$2);
  		$$.nextList = $3.nextList;
  	}
;

STATEMENT :
    DECLARATION { $$.nextList = new vector<int>();}
  | ASSIGNMENT  { $$.nextList = new vector<int>();}
  | PRINT       { $$.nextList = new vector<int>();}
  | COMMENT_LINE { $$.nextList = new vector<int>();}
  | IF { $$.nextList = $1.nextList; }
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
    TYPE ID SEMICOLON { defineVar(string($2),$1); }
;

TYPE :
    INT_WORD   { $$ = INT_T; }
  | FLOAT_WORD { $$ = FLOAT_T; }
  | BOOL_WORD  { $$ = BOOL_T; }
;

ASSIGNMENT :
    ID ASSIGN { assign_flag = true; } EXPRESSION SEMICOLON
    {
      assign_flag = false;
  		string str($1);
  		if(checkId(str))
  		{
  			if($4 == symbTab[str].second)
  			{
  				if($4 == INT_T || $4 == BOOL_T)
  				{
  					writeCode("istore " + to_string(symbTab[str].first));
  				}
          else if ($4 == FLOAT_T)
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
  			string err = "Identifier: " + str + " has not been declared.";
  			yyerror(err.c_str());
  		}
  	}
;

EXPRESSION :
    ARTH_EXPRESSION { $$ = $1; }
  | BOOL_EXPRESSION { $$ = BOOL_T; }
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
        if($$ == INT_T || $$ == BOOL_T)
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

marker:
{
	$$ = labelsCount;
	writeCode(genLabel() + ":");
}
;

goto:
{
	$$ = codeList.size();
	writeCode("goto ");
}

IF :
    IF_WORD LEFT_BRACKET BOOL_EXPRESSION RIGHT_BRACKET LEFT_BRACE marker STATEMENT_LIST RIGHT_BRACE goto ELSE_WORD LEFT_BRACE marker STATEMENT_LIST RIGHT_BRACE
    {
  		backpatch($3.trueList,$6);
  		backpatch($3.falseList,$12);
  		$$.nextList = merge($7.nextList, $13.nextList);
  		$$.nextList->push_back($9);
  	}
  | IF_WORD LEFT_BRACKET BOOL_EXPRESSION RIGHT_BRACKET LEFT_BRACE marker STATEMENT_LIST RIGHT_BRACE marker
    {
      backpatch($3.trueList,$6);
  		backpatch($3.falseList,$9);
  		$$.nextList = $7.nextList;
    }
;

BOOL_EXPRESSION :
    BOOL_EXPRESSION BINOP marker BOOL_T_EXPRESSION
    {
      if (assign_flag)
      {

      }
      else
      {
        if(!strcmp($2, "&&"))
        {
          backpatch($1.trueList, $3);
          $$.trueList = $4.trueList;
          $$.falseList = merge($1.falseList,$4.falseList);
        }
        else if (!strcmp($2,"||"))
        {
          backpatch($1.falseList,$3);
          $$.trueList = merge($1.trueList, $4.trueList);
          $$.falseList = $4.falseList;
        }
      }
  	}
  | BOOL_T_EXPRESSION
    {
      if (assign_flag)
      {

      }
      else
      {
        $$.trueList = $1.trueList;
        $$.falseList = $1.falseList;
      }
    }
;

BOOL_T_EXPRESSION :
    BOOL_T_EXPRESSION RELOP BOOL_FACTOR
    {
      if (assign_flag)
      {

      }
      else
      {
    		string op ($2);
    		$$.trueList = new vector<int>();
    		$$.trueList ->push_back (codeList.size());
    		$$.falseList = new vector<int>();
    		$$.falseList->push_back(codeList.size()+1);
    		writeCode(getOp(op)+ " ");
    		writeCode("goto ");
      }
  	}
  | BOOL_FACTOR
    {
      if (assign_flag)
      {

      }
      else
      {
        $$.trueList = $1.trueList;
        $$.falseList = $1.falseList;
      }
    }
;

BOOL_FACTOR :
    ARTH_EXPRESSION
    {
      if (assign_flag)
      {

      }
      else
      {
        if ($1 == BOOL_T){
          // ID is on top of stack
          writeCode("ldc 0"); //push zero to stack
          $$.falseList = new vector<int>();
      		$$.falseList->push_back(codeList.size()); //if result of comparing to zero if false, then the variable is true
      		writeCode("if_icmpeq "); //comparing to 0
          $$.trueList = new vector<int>();
      		$$.trueList ->push_back (codeList.size()); //vice versa
      		writeCode("goto ");
        }
      }
    }
  | TRUE
    {
      if (assign_flag)
      {
        writeCode("ldc 1");
      }
      else
      {
        $$.trueList = new vector<int> ();
  			$$.trueList->push_back(codeList.size());
  			$$.falseList = new vector<int>();
  			writeCode("goto ");
      }
    }
  | FALSE
    {
      if (assign_flag)
      {
        writeCode("ldc 0");
      }
      else
      {
        $$.trueList = new vector<int> ();
  			$$.falseList= new vector<int>();
  			$$.falseList->push_back(codeList.size());
  			writeCode("goto ");
      }
    }
  | NOTOP BOOL_EXPRESSION
    {
      if (assign_flag)
      {

      }
      else
      {
        $$.trueList = $2.falseList;
        $$.falseList = $2.trueList;
      }
    }
  | LEFT_BRACKET BOOL_EXPRESSION RIGHT_BRACKET
    {
      if (assign_flag)
      {

      }
      else
      {
        $$.trueList = $2.trueList;
        $$.falseList = $2.falseList;
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
