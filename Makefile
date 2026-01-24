# Makefile for LightningStrike

PATSCC=patscc
PATSOPT=patsopt
ATSCCFLAGS=-O2 -flto -DATS_MEMALLOC_LIBC

all: main

main: main.dats arena.dats limit.dats arena.sats types.sats limit.sats
	$(PATSCC) $(ATSCCFLAGS) -o main main.dats arena.dats limit.dats

run: main
	./main

clean:
	rm -f main *~ *.c *_?ats.o *.c
