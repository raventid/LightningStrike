(* Basic types for HFT Orderbook *)

#define ATS_PACKNAME "LightningStrike"

// Price bounds mirror materials/engine.h.
#define MIN_PRICE 1
#define MAX_PRICE 10000

// Arena capacity: matches voyager (materials/engine.c MAX_NUM_ORDERS).
// Promoted from arena.sats to types.sats so type-level constants
// (e.g. oidx_opt below) can reference it.
#define MAX_NUM_ORDERS 1010000

// Refined integer: a price is statically known to lie in [MIN_PRICE, MAX_PRICE].
// Out-of-range literals (e.g. 0 or 10001) produce a compile-time constraint
// failure at every construction site.
typedef price_t = [p:int | p >= MIN_PRICE; p <= MAX_PRICE] int p

// Quantity / size: non-negative. Cancellation (size := 0) is the lower bound;
// fills only ever subtract size when the maker has enough to cover, so the
// invariant holds across matching too.
typedef qty_t = [q:int | q >= 0] int q

typedef oid_t = int

// Trader identifier: 4 chars packed into a 4-byte value, stored inline in the
// arena entry. Mirrors voyager (`char trader[4]` in orderBookEntry_t — null is
// reconstructed at the API boundary, not stored). Opaque on the ATS side; the
// pack/unpack primitives are in arena.dats.
typedef trader_t = int

// Side: typesafe algebraic data type
datatype side_t =
  | Buy
  | Sell

// Order Entry: A node in the order book linked list.
// The arena slot index *is* the orderID — we don't store it as a separate
// field. (See docs/decisions.md Q6.) `next` is an index into the same arena
// for the price-level FIFO; -1 marks end-of-list.
typedef order_entry = @{
  size = qty_t,
  next = int,
  trader = trader_t
}

// Optional arena index: either -1 (empty/end-of-list) or a valid arena slot
// in [0, MAX_NUM_ORDERS). The disjunction is represented as the linear range
// [-1, MAX_NUM_ORDERS), since ATS's constraint solver handles linear
// inequalities, not arbitrary disjunctions. The else-branch of `if x < 0`
// then narrows to [0, MAX_NUM_ORDERS) — sufficient for a safe i2sz cast.
typedef oidx_opt = [i:int | i >= ~1; i < MAX_NUM_ORDERS] int i

// Limit Level: Represents a specific price level
typedef limit_level = @{
  limitPrice = price_t,
  totalVolume = qty_t,
  headOrder = oidx_opt,
  tailOrder = oidx_opt
}