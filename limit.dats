#include "share/atspre_staload.hats"
staload "types.sats"
staload "arena.sats"
staload "limit.sats"

implement limit_create (p) = @{
  limitPrice = p,
  totalVolume = 0,
  headOrder = ~1,
  tailOrder = ~1
}

implement limit_add_order (pf | p, lvl, oidx, size) = let
  // Update volume
  val () = lvl.totalVolume := lvl.totalVolume + size

  val tail = lvl.tailOrder       // tail: oidx_opt = [i:int | i >= -1; i < MAX_NUM_ORDERS] int i
  val oidx_int = sz2i(oidx)      // safe coercion: size_t i -> int i, with i < MAX_NUM_ORDERS
in
  if tail < 0 then let
    // List was empty: tail = -1
    val () = lvl.headOrder := oidx_int
    val () = lvl.tailOrder := oidx_int
  in
    ()
  end else let
    // tail >= 0 from if-narrowing, tail < MAX_NUM_ORDERS from oidx_opt's type.
    // Both i2sz(tail) and the arena_set_next call type-check without UNSAFE.
    val tail_sz = i2sz(tail)
    val () = arena_set_next (pf | p, tail_sz, oidx_int)
    val () = lvl.tailOrder := oidx_int
  in
    ()
  end
end
