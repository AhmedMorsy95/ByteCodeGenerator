# Makefile

OBJS	= bison.o lex.o main.o

CC	= g++
CFLAGS	= -g -Wall -ansi -pedantic

java_compiler:		$(OBJS)
		$(CC) $(CFLAGS) $(OBJS) -o java_compiler

lex.o:		lex.c
		$(CC) $(CFLAGS) -c lex.c -o lex.o

lex.c:		token_grammar.l
		flex token_grammar.l
		cp lex.yy.c lex.c

bison.o:	bison.c
		$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	java_cfg.y lex.c
		bison -d -v java_cfg.y
		cp java_cfg.tab.c bison.c
		cmp -s java_cfg.tab.h tok.h || cp java_cfg.tab.h tok.h

main.o:		main.cc lex.c bison.c
		$(CC) $(CFLAGS) -c main.cc -o main.o

lex.o yac.o main.o	: heading.h
lex.o main.o		: tok.h

clean:
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h java_cfg.tab.c java_cfg.tab.h java_cfg.output
