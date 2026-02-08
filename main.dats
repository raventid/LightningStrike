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

  // Allocate Order 1 — orderID is the returned slot index (no separate oid).
  var free_idx: size_t = i2sz(0)
  val size1 = 10
  val idx1 = arena_alloc_order (pf_arena | p_arena, free_idx, size1, "TraderA")
  val () = println! ("Allocated Order 1 at index: ", idx1)

  // Add Order 1 to Limit (idx1 is already a bounded size_t — no cast needed)
  val () = limit_add_order (pf_arena | p_arena, my_limit, idx1, size1)
  val () = println! ("Added Order 1 to Limit.")

  // Allocate Order 2
  val size2 = 20
  val idx2 = arena_alloc_order (pf_arena | p_arena, free_idx, size2, "TraderB")
  val () = println! ("Allocated Order 2 at index: ", idx2)

  val () = limit_add_order (pf_arena | p_arena, my_limit, idx2, size2)
  val () = println! ("Added Order 2 to Limit.")

  // Check Limit Status
  val () = println! ("Limit Price: ", my_limit.limitPrice)
  val () = println! ("Limit Volume: ", my_limit.totalVolume)
  val () = println! ("Limit Head: ", my_limit.headOrder)
  val () = println! ("Limit Tail: ", my_limit.tailOrder)

  // Smoke-probe arena_get_size / arena_set_size (Step 11).
  val sz1_before = arena_get_size (pf_arena | p_arena, idx1)
  val sz2 = arena_get_size (pf_arena | p_arena, idx2)
  val () = println! ("Order 1 size (before cancel): ", sz1_before)
  val () = println! ("Order 2 size: ", sz2)

  val () = arena_set_size (pf_arena | p_arena, idx1, 0)
  val sz1_after = arena_get_size (pf_arena | p_arena, idx1)
  val () = println! ("Order 1 size (after cancel):  ", sz1_after)
  val () = assertloc (sz1_after = 0)

  // Clean up
  val () = arena_free (pf_arena, pf_gc | p_arena)
  val () = println! ("Arena Freed.")
in
  ()
end
