#!/bin/sh

make;
make clean;
echo "Running byte code generator"
./java_compiler
