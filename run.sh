#!/bin/sh

make;
if [ $? -eq 0 ]; then
  make clean;
  if [ $? -eq 0 ]; then
    echo "Build succeeded."
    echo "Running output file"
    ./java_compiler simple_test.in
    if [ $? -eq 0 ]; then
      jasmin bytecode.j
      if [ $? -eq 0 ]; then
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
