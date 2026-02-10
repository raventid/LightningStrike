(* Price-Level Array
 *
 * Mirrors voyager's pricePoints[MAX_PRICE + 1]: a flat array of limit_level
 * structs indexed by price. Each slot holds head / tail / totalVolume for the
 * orders resting at that price. Slot 0 is unused (MIN_PRICE = 1).
 *
 * The matching engine walks askMin upward (buys) or bidMax downward (sells)
 * through this array, following each level's chain via the arena's `next`.
 *)

#include "types.sats"
staload "arena.sats"

// Array size: prices in [MIN_PRICE, MAX_PRICE] with slot 0 unused.
// 10001 entries; ATS doesn't accept arithmetic in type positions, so the
// constant is precomputed here. If MAX_PRICE changes in types.sats, update.
#define LEVELS_SIZE 10001

// Linear array of limit_level entries. Same shape as arena_vt.
viewtypedef levels_vt = @[limit_level][LEVELS_SIZE]

// Allocate and zero-initialize the price-point array.
fun levels_create (): [l:addr] (levels_vt @ l, mfree_gc_v l | ptr l)

// Free the array.
fun levels_free {l:addr} (
  pf: levels_vt @ l,
  pf_gc: mfree_gc_v l |
  p: ptr l
): void

// Read a copy of the level at `price`.
fun levels_get {l:addr} (
  pf: !levels_vt @ l |
  p: ptr l,
  price: price_t
): limit_level

// Write `lvl` back at `price`.
fun levels_set {l:addr} (
  pf: !levels_vt @ l |
  p: ptr l,
  price: price_t,
  lvl: limit_level
): void

// Append an order at the given price (FIFO). Combines read-update-write of
// the level entry plus an arena_set_next on the previous tail if non-empty.
// Mirrors voyager's ppInsertOrder.
fun levels_append {l_lv:addr} {l_ar:addr} {i:nat | i < MAX_NUM_ORDERS} (
  pf_lv: !levels_vt @ l_lv,
  pf_ar: !arena_vt @ l_ar |
  p_lv: ptr l_lv,
  p_ar: ptr l_ar,
  price: price_t,
  oidx: size_t i,
  size: qty_t
): void
