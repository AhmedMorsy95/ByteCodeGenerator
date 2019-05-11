#!/bin/sh

flex -o token_grammar.yy.c token_grammar.l
gcc token_grammar.yy.c
