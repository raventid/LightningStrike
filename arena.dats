#include "share/atspre_staload.hats"
#include "arena.sats"

implement arena_create () = let
  val (pf_arr, pf_gc | p_arr) = array_ptr_alloc<order_entry>(i2sz(MAX_ORDERS))
  
  // Initialize with a default value
  val init_val = @{size=0, next= ~1, trader=""}
  val () = array_initize_elt<order_entry>(!p_arr, i2sz(MAX_ORDERS), init_val)
in
  (pf_arr | p_arr)
end
