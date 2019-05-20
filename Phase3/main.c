#include <stdio.h>
#include "parse.tab.h"

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
