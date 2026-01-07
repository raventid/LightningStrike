(* Memory Arena for Orders *)

#include "types.sats"

#define MAX_ORDERS 1000000

// Linear array of order entries
viewtypedef arena_vt = @[order_entry][MAX_ORDERS]

// Function to allocate the arena
// Returns a pointer to the array and the proof of its view
fun arena_create (): [l:addr] (arena_vt @ l | ptr l)
