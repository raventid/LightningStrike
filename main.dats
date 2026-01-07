#include "share/atspre_staload.hats"
staload "types.sats"
staload "arena.sats"

implement main0 () = let
  val () = println! ("Initializing Arena...")
  val (pf_arena | p_arena) = arena_create ()
  val () = println! ("Arena Initialized.")
  // In a real app we would keep this. For now we just leak it to exit.
  // We can't easily "free" the view without a free function, so this might cause a type error
  // if ATS is strict about linear variable dropping in main.
  // But let's see. 
in
  ()
end
