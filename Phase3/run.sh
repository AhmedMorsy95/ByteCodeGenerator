#!/bin/sh

flex lex.l;
if [ $? -eq 0 ]; then
  bison -d parse.y;
  if [ $? -eq 0 ]; then
    gcc main.c lex.yy.c parse.tab.c;
    if [ $? -eq 0 ]; then
      echo "Build succeeded."
      echo "Running output file"
      ./a.out
    else
      echo "Compile has failed"
    fi
  else
    echo "Bison has failed"
  fi
else
  echo "Flex has failed"
fi
