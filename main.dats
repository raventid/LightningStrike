#include "share/atspre_staload.hats"
// We need to staload libc for malloc/free availability if using default allocator
staload "libats/libc/SATS/stdlib.sats" 

staload "types.sats"
staload "arena.sats"
staload "limit.sats"

implement main0 () = let
  val () = println! ("Initializing Arena...")
  val (pf_arena, pf_gc | p_arena) = arena_create ()
  val () = println! ("Arena Initialized.")

  // Create a limit
  var my_limit = limit_create (100)
  val () = println! ("Created Limit Level at ", my_limit.limitPrice)

  // Allocate Order 1
  var free_idx: size_t = i2sz(0)
  val oid1 = 101
  val size1 = 10
  val idx1 = arena_alloc_order (pf_arena | p_arena, free_idx, oid1, size1, "TraderA")
  val () = println! ("Allocated Order 1 at index: ", idx1)
  
  // Add Order 1 to Limit
  val idx1_sz = $UNSAFE.cast{ [i:nat | i < MAX_ORDERS] size_t(i) } (idx1)
  val () = limit_add_order (pf_arena | p_arena, my_limit, idx1_sz, size1)
  val () = println! ("Added Order 1 to Limit.")

  // Allocate Order 2
  val oid2 = 102
  val size2 = 20
  val idx2 = arena_alloc_order (pf_arena | p_arena, free_idx, oid2, size2, "TraderB")
  val () = println! ("Allocated Order 2 at index: ", idx2)

  val idx2_sz = $UNSAFE.cast{ [i:nat | i < MAX_ORDERS] size_t(i) } (idx2)
  val () = limit_add_order (pf_arena | p_arena, my_limit, idx2_sz, size2)
  val () = println! ("Added Order 2 to Limit.")

  // Check Limit Status
  val () = println! ("Limit Price: ", my_limit.limitPrice)
  val () = println! ("Limit Volume: ", my_limit.totalVolume)
  val () = println! ("Limit Head: ", my_limit.headOrder)
  val () = println! ("Limit Tail: ", my_limit.tailOrder)
  
  // Clean up
  val () = arena_free (pf_arena, pf_gc | p_arena)
  val () = println! ("Arena Freed.")
in
  ()
end
