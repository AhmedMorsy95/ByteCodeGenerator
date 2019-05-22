#!/bin/sh
echo "=============== Compiling ==============="
make;
if [ $? -eq 0 ]; then
  echo ""
  echo "=============== Cleaning ==============="
  make clean;
  if [ $? -eq 0 ]; then
    echo ""
    echo "=============== Generating Bytecode ==============="
    ./java_compiler code.in
    if [ $? -eq 0 ]; then
      echo ""
      echo "=============== Generating Executable Java Class ==============="
      jasmin bytecode.j
      if [ $? -eq 0 ]; then
        echo ""
        echo "=============== Running Java Code ==============="
        echo "Java output is: "
        java test
      else
        echo "Jasmin has failed to compile bytecode"
      fi
    else
      echo "Parser has failed"
    fi
  else
    echo "Clean has failed"
  fi
else
  echo "Make has failed"
fi
