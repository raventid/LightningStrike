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
  
  val tail = lvl.tailOrder
  val oidx_int = $UNSAFE.cast{int}(oidx)
in
  if tail < 0 then let
    // List was empty
    val () = lvl.headOrder := oidx_int
    val () = lvl.tailOrder := oidx_int
  in
    ()
  end else let
    // List not empty, append to tail
    // We assume tail is a valid index < MAX_ORDERS if it is >= 0
    val () = assertloc (tail >= 0)
    val tail_sz = $UNSAFE.cast{ [i:nat | i < MAX_ORDERS] size_t(i) } (tail)
    val () = arena_set_next (pf | p, tail_sz, oidx_int)
    val () = lvl.tailOrder := oidx_int
  in
    ()
  end
end
