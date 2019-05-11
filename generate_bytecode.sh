#!/bin/sh

flex -o token_grammar.yy.c token_grammar.l
gcc -o lexical_analyzer.o token_grammar.yy.c
./lexical_analyzer.o
