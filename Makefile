# Simple Makefile for ATS Hello World

PATSCC=patscc
PATSOPT=patsopt

all: main

main: main.dats
	$(PATSCC) -o main main.dats

clean:
	rm -f main *~ *_?ats.c *_?ats.o