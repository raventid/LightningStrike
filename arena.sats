(* Memory Arena for Orders *)

#include "types.sats"

// MAX_NUM_ORDERS now lives in types.sats so refined types like oidx_opt can
// reference it.

// Linear array of order entries
viewtypedef arena_vt = @[order_entry][MAX_NUM_ORDERS]

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
fun arena_set_next {l:addr} {i:nat | i < MAX_NUM_ORDERS} (
  pf: !arena_vt @ l |
  p: ptr l,
  idx: size_t i,
  next_val: int
): void

// Read the current size of the order at idx. Used by matching to know how
// much liquidity the resting order has, and by cancellation tests.
fun arena_get_size {l:addr} {i:nat | i < MAX_NUM_ORDERS} (
  pf: !arena_vt @ l |
  p: ptr l,
  idx: size_t i
): qty_t

// Mutate the size of the order at idx. Cancellation sets it to 0 (voyager's
// soft delete); matching decrements it on partial fills.
fun arena_set_size {l:addr} {i:nat | i < MAX_NUM_ORDERS} (
  pf: !arena_vt @ l |
  p: ptr l,
  idx: size_t i,
  new_size: qty_t
): void

// Allocate a new order in the arena.
// The returned `size_t i` is the slot index, which doubles as the orderID
// (see docs/decisions.md Q6). The dependent return type lets callers thread
// the bound `i < MAX_NUM_ORDERS` through subsequent calls without an
// $UNSAFE.cast at every step. free_idx is bumped on success; we require
// free_idx < MAX_NUM_ORDERS at entry.
fun arena_alloc_order {l:addr} {i:nat | i < MAX_NUM_ORDERS} (
  pf: !arena_vt @ l |
  p: ptr l,
  free_idx: &size_t i >> size_t (i+1),
  size: qty_t,
  trader: string
): size_t i
