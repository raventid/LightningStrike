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
  size = qty_t,
  next = int, // -1 indicates end of list
  trader = string // Simplified for now
}