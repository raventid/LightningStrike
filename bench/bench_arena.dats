(*
 * bench/bench_arena.dats
 *
 * Microbench for arena_set_next: measures ns/op of the read-copy-write
 * mutation pattern in arena.dats. The result feeds the Step 11 decision
 * (RCW vs in-place mutation via array_get_ref).
 *
 * Risk gate: if this is more than ~2x slower than a single-store mutation,
 * we should switch to in-place mutation when implementing arena_set_size.
 *
 * Loop walks indices 0..MAX_NUM_ORDERS-1 cyclically so cache behavior
 * reflects realistic working-set traversal, not a single hot slot.
 *)

#include "share/atspre_staload.hats"
staload "types.sats"
staload "arena.sats"

#define ITERS 10000000

%{^
#include <time.h>
static struct timespec _bench_t0, _bench_t1;
void bench_start_(void) { clock_gettime(CLOCK_MONOTONIC, &_bench_t0); }
void bench_end_(void)   { clock_gettime(CLOCK_MONOTONIC, &_bench_t1); }
int bench_total_ns_(void) {
  long ns = (long)(_bench_t1.tv_sec  - _bench_t0.tv_sec)  * 1000000000L
          + (long)(_bench_t1.tv_nsec - _bench_t0.tv_nsec);
  return (int)ns;
}
/* Picoseconds per op = (total_ns * 1000) / iters. Done in long to avoid
   overflow before truncation back to int for ATS. */
int bench_ps_per_op_(int iters) {
  long ns = (long)(_bench_t1.tv_sec  - _bench_t0.tv_sec)  * 1000000000L
          + (long)(_bench_t1.tv_nsec - _bench_t0.tv_nsec);
  return (int)((ns * 1000L) / (long)iters);
}
%}

extern fun bench_start_       (): void = "mac#"
extern fun bench_end_         (): void = "mac#"
extern fun bench_total_ns_    (): int  = "mac#"
extern fun bench_ps_per_op_   (iters: int): int = "mac#"

implement main0 () = let
  val (pf, pf_gc | p) = arena_create()

  val () = bench_start_ ()

  var i: int = 0
  val () = while (i < ITERS) let
    val idx_int = i mod MAX_NUM_ORDERS
    val idx = $UNSAFE.cast{ [j:nat | j < MAX_NUM_ORDERS] size_t(j) } (idx_int)
    val () = arena_set_next (pf | p, idx, i)
  in
    i := i + 1
  end

  val () = bench_end_ ()

  val ns_total = bench_total_ns_ ()
  val ps_per   = bench_ps_per_op_ (ITERS)

  val () = println! ("arena_set_next x ", ITERS, ":")
  val () = println! ("  total:  ", ns_total, " ns")
  val () = println! ("  per-op: ", ps_per, " ps  (", ps_per / 1000, ".",
                                                   (ps_per mod 1000) / 100, " ns)")

  val () = arena_free (pf, pf_gc | p)
in
  ()
end
