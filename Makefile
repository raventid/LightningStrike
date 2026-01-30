# Makefile for LightningStrike

PATSCC=patscc
PATSOPT=patsopt
ATSCCFLAGS=-O2 -flto -DATS_MEMALLOC_LIBC
CC=cc
CCFLAGS=-O2 -Wall

all: main

main: main.dats arena.dats limit.dats arena.sats types.sats limit.sats
	$(PATSCC) $(ATSCCFLAGS) -o main main.dats arena.dats limit.dats

run: main
	./main

# ---- Benches --------------------------------------------------------------

bench/bench_arena: bench/bench_arena.dats arena.dats arena.sats types.sats
	$(PATSCC) $(ATSCCFLAGS) -o $@ bench/bench_arena.dats arena.dats

bench-arena: bench/bench_arena
	./bench/bench_arena

# ---- Tests ----------------------------------------------------------------

# Reference oracle: materials/engine.c with symbols renamed to oracle_*.
tests/oracle.o: tests/oracle_shim.c materials/engine.c materials/engine.h
	$(CC) $(CCFLAGS) -c -o $@ $<

# Stub target — populated as test files land in tests/.
test: tests/oracle.o
	@nm $< | grep -q ' T _\?oracle_init'   || (echo "oracle_init missing"   && exit 1)
	@nm $< | grep -q ' T _\?oracle_limit'  || (echo "oracle_limit missing"  && exit 1)
	@nm $< | grep -q ' T _\?oracle_cancel' || (echo "oracle_cancel missing" && exit 1)
	@echo "test: 0 tests, 0 failures (oracle.o symbols verified)"

clean:
	rm -f main *~ *.c *_?ats.o *.c
	rm -f tests/*.o tests/test_runner
	rm -f bench/*.o bench/bench_arena bench/*_?ats.c
