# Makefile for LightningStrike

PATSCC=patscc
PATSOPT=patsopt
ATSCCFLAGS=-O2 -flto

all: main

main: main.dats arena.dats
	$(PATSCC) $(ATSCCFLAGS) -o main main.dats arena.dats

clean:
	rm -f main *~ *_?ats.c *_?ats.o
