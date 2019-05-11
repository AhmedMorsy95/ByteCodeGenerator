
/*** Definition Section that may have variables
which can be accessed inside yylex()
and main() ***/

%{
  /* we can use variables here */
%}

delim	  [ \t\n]
ws      {delim}+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
num  	  {digit}+(\.{digit}+)?(E[+-I]?{digit}+)?
relop	  (<)|(<\=)|(>)|(>\=)|(\=\=)|(!\=)
addop   \+|-
mulop	  (\*)|(\/)
assign  \=
%%

boolean   {printf("boolean\n");}
int       {printf("int\n");}
float 	  {printf("float\n");}
ws	      {}
if   	    {printf("if\n");}
else 	    {printf("else\n");}
while 	  {printf("while\n");}
{id}	    {printf("id|%s\n", yytext);}
{num}	    {printf("number|%s\n", yytext);}
{relop}	  {printf("relop|%s\n", yytext);}
{addop}	  {printf("addop|%s\n", yytext);}
{mulop}	  {printf("mulop|%s\n", yytext);}
{assign}	{printf("assign\n");}
\(	      {printf("(\n");}
\)	      {printf(")\n");}
{	        {printf("{\n");}
}	        {printf("}\n");}
,	        {printf(",\n");}
;	        {printf(";\n");}
%%

/*** Code Section***/
int yywrap(){}
int main(){
  /*
  Explanation:
  yywrap() - wraps the above rule section
  yyin - takes the file pointer
            which contains the input
  yylex() - this is the main flex function
            which runs the Rule Section
  yytext is the text in the buffer
  */
  FILE *fp;
  fp = fopen("code.in","r");
  yyin = fp;
  yylex();
  return 0;
}
