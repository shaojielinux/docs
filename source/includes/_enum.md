# Constant definitions


## Order side
Order side    | Description
---------            | ----------------
buy                | Buy
sell               | Sell


## Order type
OrderType            | Description
---------            | ----------------
limit                | Limit order
market               | Market order


## Order status
Status | Description
--- | ---
pending | Order initial state
open | Order active state 
filled | Order fully filled
cancelled | Order is cancelled


## Order time in force
Status | Description
--- | ---
gtc | Good till cancel
fok | Fill or kill
ioc | Immediate or cancel

## Transaction log type
Tx log type          | Description
---------            | ----------------
trade-pay            | Paying out cash for a trade
trade-recv           | Receiving cash of a trade
fee-collection       | Collecting fee
deposit              | Deposit
deposit-rollback     | Deposit rollback
withdraw             | Withdraw
withdraw-refund      | Withdraw refund
transfer-in          | Fund transfer in
transfer-out         | Fund transfer out

## Order source
Order source    | Description
---------       | ----------------
api             | From API
web             | From Web GUI
app             | From mobile app
