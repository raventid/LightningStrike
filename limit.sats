staload "types.sats"
staload "arena.sats"

fun limit_create (p: price_t): limit_level

// Add an order (referenced by oidx) to the limit level
fun limit_add_order {l:addr} {i:nat | i < MAX_NUM_ORDERS} (
  pf: !arena_vt @ l |
  p: ptr l,
  lvl: &limit_level >> _,
  oidx: size_t i,
  size: qty_t
): void
