/* heading.h */
#ifndef HEADINGS
# define HEADINGS
#define GetCurrentDir getcwd

#include <stdio.h>
#include <fstream>
#include <iostream>
#include <map>
#include <cstring>
#include <vector>
#include <unistd.h>
#include <string>
#include "parse.tab.h"
#include "bytecode_inst.h"

using namespace std;

typedef enum {INT_T, FLOAT_T, BOOL_T, VOID_T, ERROR_T} type_enum;

ofstream fout("bytecode.j");	/* file for writing output */
int varaiblesNum = 1; 	/* new variable will be issued this number, java starts with 1, 0 is 'this' */
int labelsCount = 0;	/* to generate labels */
string outfileName;
map<string, pair<int,type_enum> > symbTab;
vector<string> codeList;

void yyerror(char const *s)
{
	fprintf(stderr, "%s\n", s);
}

void writeCode(string x)
{
	codeList.push_back(x);
}

bool checkId(string op)
{
	return (symbTab.find(op) != symbTab.end());
}

void defineVar(string name, int type)
{
	if(checkId(name))
	{
		string err = "variable: "+name+" declared before";
		yyerror(err.c_str());
	}
	else
	{
		if(type == INT_T || type == BOOL_T)
		{
			writeCode("iconst_0\nistore " + to_string(varaiblesNum));
		}
		else if ( type == FLOAT_T)
		{
			writeCode("fconst_0\nfstore " + to_string(varaiblesNum));
		}
		symbTab[name] = make_pair(varaiblesNum++,(type_enum)type);
	}
}

string getOp(string op)
{
	if(inst_list.find(op) != inst_list.end())
	{
		return inst_list[op];
	}
	return "";
}

void printLineNumber(int num)
{
	writeCode(".line "+ to_string(num));
}

void generateHeader()
{
	writeCode(".source " + outfileName);
	writeCode(".class public test\n.super java/lang/Object\n"); //code for defining class
	writeCode(".method public <init>()V");
	writeCode("aload_0");
	writeCode("invokenonvirtual java/lang/Object/<init>()V");
	writeCode("return");
	writeCode(".end method\n");
	writeCode(".method public static main([Ljava/lang/String;)V");
	writeCode(".limit locals 100\n.limit stack 100");

	/* generate temporal vars for syso */
	defineVar("1syso_int_var",INT_T);
	defineVar("1syso_float_var",FLOAT_T);

	/*generate line*/
	writeCode(".line 1");
}

void generateFooter()
{
	writeCode("return");
	writeCode(".end method");
}

void cast (string str, int t1)
{
	yyerror("casting not implemented yet :)");
}

void arithCast(int from , int to, string op)
{
	if(from == to)
	{
		if(from == INT_T)
		{
			writeCode("i" + getOp(op));
		}
		else if (from == FLOAT_T)
		{
			writeCode("f" + getOp(op));
		}
	}
	else
	{
		yyerror("Different types in expression. Not supported yet");
	}
}

string genLabel()
{
	return "L_" + to_string(labelsCount++);
}

string getLabel(int n)
{
	return "L_" + to_string(n);
}

vector<int> * merge(vector<int> *list1, vector<int> *list2)
{
	if(list1 && list2){
		vector<int> *list = new vector<int> (*list1);
		list->insert(list->end(), list2->begin(),list2->end());
		return list;
	}
	else if(list1)
	{
		return list1;
	}
	else if (list2)
	{
		return list2;
	}
	else
	{
		return new vector<int>();
	}
}

void backpatch(vector<int> *lists, int ind)
{
	if(lists)
	{
		for(int i = 0; i < lists->size(); i++)
		{
			codeList[(*lists)[i]] += getLabel(ind);
		}
	}
}

void printCode(void)
{
	for ( int i = 0 ; i < codeList.size() ; i++)
	{
		fout<<codeList[i]<<endl;
	}
}

#endif /* !HEADINGS */
