(* Memory Arena for Orders *)

#include "types.sats"

#define MAX_ORDERS 100

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
fun arena_set_next {l:addr} {i:nat | i < MAX_ORDERS} (
  pf: !arena_vt @ l |
  p: ptr l,
  idx: size_t i,
  next_val: int
): void

// Allocate a new order in the arena
// Returns the index of the new order
// free_idx is updated. We require free_idx < MAX_ORDERS
fun arena_alloc_order {l:addr} {i:nat | i < MAX_ORDERS} (
  pf: !arena_vt @ l |
  p: ptr l,
  free_idx: &size_t i >> size_t (i+1),
  oid: oid_t,
  size: qty_t,
  trader: string
): int
