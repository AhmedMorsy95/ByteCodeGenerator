#include <stdio.h>
#include "parse.tab.h"
#include <string>

using namespace std;

void yyerror(char const *s);

int main(int argc, char **argv)
{
	if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  {
		printf("%s: File %s cannot be opened", argv[0], argv[1]);
    return 1;
  }
	yyparse();
	return 0;
}

void yyerror(char const *s)
{
	fprintf(stderr, "%s\n", s);
}
//
// string outfileName;
//
// void generateHeader()
// {
// 	writeCode(".source " + outfileName);
// 	writeCode(".class public test\n.super java/lang/Object\n"); //code for defining class
// 	writeCode(".method public <init>()V");
// 	writeCode("aload_0");
// 	writeCode("invokenonvirtual java/lang/Object/<init>()V");
// 	writeCode("return");
// 	writeCode(".end method\n");
// 	writeCode(".method public static main([Ljava/lang/String;)V");
// 	writeCode(".limit locals 100\n.limit stack 100");
//
// 	/* generate temporal vars for syso */
// 	defineVar("1syso_int_var",INT);
// 	defineVar("1syso_float_var",FLOAT);
//
// 	/*generate line*/
// 	writeCode(".line 1");
// }
//
// void generateHeader()
// {
// 	writeCode(".source " + outfileName);
// 	writeCode(".class public test\n.super java/lang/Object\n"); //code for defining class
// 	writeCode(".method public <init>()V");
// 	writeCode("aload_0");
// 	writeCode("invokenonvirtual java/lang/Object/<init>()V");
// 	writeCode("return");
// 	writeCode(".end method\n");
// 	writeCode(".method public static main([Ljava/lang/String;)V");
// 	writeCode(".limit locals 100\n.limit stack 100");
//
// 	/* generate temporal vars for syso*/
// 	defineVar("1syso_int_var",INT);
// 	defineVar("1syso_float_var",FLOAT);
//
// 	/*generate line*/
// 	writeCode(".line 1");
// }
//
// void generateFooter()
// {
// 	writeCode("return");
// 	writeCode(".end method");
// }
//
// void cast (string str, int t1)
// {
// 	yyerror("casting not implemented yet :)");
// }
//
// void arithCast(int from , int to, string op)
// {
// 	if(from == to)
// 	{
// 		if(from == INT_T)
// 		{
// 			writeCode("i" + getOp(op));
// 		}else if (from == FLOAT_T)
// 		{
// 			writeCode("f" + getOp(op));
// 		}
// 	}
// 	else
// 	{
// 		yyerror("cast not implemented yet");
// 	}
// }
//
//
// string getOp(string op)
// {
// 	if(inst_list.find(op) != inst_list.end())
// 	{
// 		return inst_list[op];
// 	}
// 	return "";
// }
//
// bool checkId(string op)
// {
// 	return (symbTab.find(op) != symbTab.end());
// }
//
// void defineVar(string name, int type)
// {
// 	if(checkId(name))
// 	{
// 		string err = "variable: "+name+" declared before";
// 		yyerror(err.c_str());
// 	}else
// 	{
// 		if(type == INT_T)
// 		{
// 			writeCode("iconst_0\nistore " + to_string(varaiblesNum));
// 		}
// 		else if ( type == FLOAT_T)
// 		{
// 			writeCode("fconst_0\nfstore " + to_string(varaiblesNum));
// 		}
// 		symbTab[name] = make_pair(varaiblesNum++,(type_enum)type);
// 	}
// }
//
// string genLabel()
// {
// 	return "L_"+to_string(labelsCount++);
// }
//
// string getLabel(int n)
// {
// 	return "L_"+to_string(n);
// }
//
// vector<int> * merge(vector<int> *list1, vector<int> *list2)
// {
// 	if(list1 && list2){
// 		vector<int> *list = new vector<int> (*list1);
// 		list->insert(list->end(), list2->begin(),list2->end());
// 		return list;
// 	}else if(list1)
// 	{
// 		return list1;
// 	}else if (list2)
// 	{
// 		return list2;
// 	}else
// 	{
// 		return new vector<int>();
// 	}
// }
// void backpatch(vector<int> *lists, int ind)
// {
// 	if(lists)
// 	for(int i =0 ; i < lists->size() ; i++)
// 	{
// 		codeList[(*lists)[i]] = codeList[(*lists)[i]] + getLabel(ind);
// //		printf("%s\n",codeList[(*lists)[i]].c_str());
// 	}
// }
// void writeCode(string x)
// {
// 	codeList.push_back(x);
// }
//
// void printCode(void)
// {
// 	for ( int i = 0 ; i < codeList.size() ; i++)
// 	{
// 		fout<<codeList[i]<<endl;
// 	}
// }
