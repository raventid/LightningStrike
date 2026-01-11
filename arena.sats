(* Memory Arena for Orders *)

#include "types.sats"

#define MAX_ORDERS 1000000

// Linear array of order entries
viewtypedef arena_vt = @[order_entry][MAX_ORDERS]

// Function to allocate the arena
// Returns a pointer to the array, the proof of its view, and the GC proof
fun arena_create (): [l:addr] (arena_vt @ l, mfree_gc_v l | ptr l)

// Free the arena
fun arena_free {l:addr} (
  pf: arena_vt @ l,
  pf_gc: mfree_gc_v l |
  p: ptr l
): void

// Set the next index for an order at idx
fun arena_set_next {l:addr} (
  pf: !arena_vt @ l |
  p: ptr l,
  idx: size_t,
  next_val: int
): void
