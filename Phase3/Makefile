# Makefile

OBJS	= bison.o lex.o main.o

CC	= g++
CFLAGS	= -g -Wall -ansi -pedantic -std=c++11

java_compiler:		$(OBJS)
		$(CC) $(CFLAGS) $(OBJS) -o java_compiler

lex.o:	lex.c
		$(CC) $(CFLAGS) -c lex.c -o lex.o

lex.c:		lex.l
		flex lex.l
		cp lex.yy.c lex.c

bison.o:	bison.c
		$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	parse.y lex.c
		bison -d -v parse.y
		cp parse.tab.c bison.c
		cmp -s parse.tab.h tok.h || cp parse.tab.h tok.h

main.o:		main.c lex.c bison.c
		$(CC) $(CFLAGS) -c main.c -o main.o

lex.o yac.o main.o	: heading.h
lex.o main.o		: tok.h

clean:
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h parse.tab.c parse.tab.h parse.output
