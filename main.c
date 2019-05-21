#include <stdio.h>
#include <string>
#include "parse.tab.h"

using namespace std;

int main(int argc, char **argv)
{
	if ((argc > 1) && (freopen(argv[1], "r", stdin) == NULL))
  {
		printf("%s: File %s cannot be opened", argv[0], argv[1]);
    return 1;
  }
	extern string outfileName;
	outfileName = argv[1];
	yyparse();
	return 0;
}
