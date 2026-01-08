(* Basic types for HFT Orderbook *)

#define ATS_PACKNAME "LightningStrike"

typedef price_t = int
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