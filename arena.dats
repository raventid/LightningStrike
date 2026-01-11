#include "share/atspre_staload.hats"
#include "arena.sats"

implement arena_create () = let
  val (pf_arr, pf_gc | p_arr) = array_ptr_alloc<order_entry>(i2sz(MAX_ORDERS))
  
  // Initialize with a default value
  val init_val = @{oid=0, size=0, next= ~1, trader=""}
  val () = array_initize_elt<order_entry>(!p_arr, i2sz(MAX_ORDERS), init_val)
in
  (pf_arr, pf_gc | p_arr)
end

implement arena_free (pf, pf_gc | p) = let
  val () = array_ptr_free (pf, pf_gc | p)
in
  ()
end

implement arena_set_next (pf | p, idx, next_val) = let
  // Read existing value
  val old_entry = array_get_at_guint<order_entry> (!p, idx)
  // Create new value with updated next
  val new_entry = @{
    oid = old_entry.oid,
    size = old_entry.size,
    next = next_val,
    trader = old_entry.trader
  }
  // Write back
  val () = array_set_at_guint<order_entry> (!p, idx, new_entry)
in
  ()
end
