#include "share/atspre_staload.hats"
staload "arena.sats"

%{^
#include <string.h>
/* Pack the first 4 bytes of a trader name into an int. Bytes past the end of
   a shorter input string are zero-filled. Mirrors voyager's char[4] storage. */
static int trader_pack_(const char *s) {
  int r = 0;
  size_t n = strnlen(s, 4);
  memcpy(&r, s, n);
  return r;
}
%}

extern fun trader_pack (s: string): trader_t = "mac#trader_pack_"

implement arena_create () = let
  val (pf_arr, pf_gc | p_arr) = array_ptr_alloc<order_entry>(i2sz(MAX_NUM_ORDERS))

  // Initialize with a default value (trader = 0 = all-null bytes)
  val init_val = @{oid=0, size=0, next= ~1, trader=0}
  val () = array_initize_elt<order_entry>(!p_arr, i2sz(MAX_NUM_ORDERS), init_val)
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
  // idx is now known to be < MAX_NUM_ORDERS statically
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

implement arena_alloc_order (pf | p, free_idx, oid, size, trader) = let
  val idx = free_idx
  // We know free_idx < MAX_NUM_ORDERS from the signature
  
  val new_entry = @{
    oid = oid,
    size = size,
    next = ~1,
    trader = trader_pack(trader)
  }

  val () = array_set_at_guint<order_entry> (!p, idx, new_entry)
  val () = free_idx := idx + 1
in
  $UNSAFE.cast{int}(idx)
end
