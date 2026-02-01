(* Basic types for HFT Orderbook *)

#define ATS_PACKNAME "LightningStrike"

// Price bounds mirror materials/engine.h.
#define MIN_PRICE 1
#define MAX_PRICE 10000

// Refined integer: a price is statically known to lie in [MIN_PRICE, MAX_PRICE].
// Out-of-range literals (e.g. 0 or 10001) produce a compile-time constraint
// failure at every construction site.
typedef price_t = [p:int | p >= MIN_PRICE; p <= MAX_PRICE] int p

typedef qty_t = int
typedef oid_t = int

// Side: typesafe algebraic data type
datatype side_t = 
  | Buy
  | Sell

// Order Entry: A node in the order book linked list
// We use an index 'next' for array-based linking
typedef order_entry = @{
  oid = oid_t,
  size = qty_t,
  next = int, // -1 indicates end of list
  trader = string // Simplified for now
}

// Limit Level: Represents a specific price level
typedef limit_level = @{
  limitPrice = price_t,
  totalVolume = qty_t,
  headOrder = int, // Index into arena
  tailOrder = int  // Index into arena
}