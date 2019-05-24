# ByteCodeGenerator

This C++ code transforms any simple java code to its corresponding JVM bytecode. Which is then compiled into a **.class** file and is run on a JVM.

# Instructions and how to run

1. Add the Java code you want to compile in **code.in** file
2. Run the bash script using `./run.sh` or `sh run.sh`

## Dependecies
1. [Flex](https://github.com/westes/flex)
2. [Bison](https://www.gnu.org/software/bison/)
3. [Jasmin](http://jasmin.sourceforge.net/)

## What does `run.sh` do?
1. Compiles the code using a makefile
2. Cleans the working environment after compiling
3. Runs the result executable file with **code.in** as input
4. Runs **Jasmin** to compile the bytecode into a **.class** file that can be executed on JVM
5. Runs the **.class** file on JVM and prints the output
