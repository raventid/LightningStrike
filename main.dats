#include "share/atspre_staload.hats"
// We need to staload libc for malloc/free availability if using default allocator
staload "libats/libc/SATS/stdlib.sats" 

staload "types.sats"
staload "arena.sats"

implement main0 () = let
  val () = println! ("Initializing Arena...")
  val (pf_arena, pf_gc | p_arena) = arena_create ()
  val () = println! ("Arena Initialized.")
  
  // Clean up
  val () = arena_free (pf_arena, pf_gc | p_arena)
  val () = println! ("Arena Freed.")
in
  ()
end
