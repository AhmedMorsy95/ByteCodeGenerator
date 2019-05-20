#!/bin/sh

make;
if [ $? -eq 0 ]; then
  make clean;
  if [ $? -eq 0 ]; then
    echo "Build succeeded."
    echo "Running output file"
    ./java_compiler
  else
    echo "Clean has failed"
  fi
else
  echo "Make has failed"
fi
