# API summary

* User defined string fields(label etc): valid characters are [A-Z], [a-z], [0-9], "-", "_"

<aside class="notice">
API key is not required for public endpoint
</aside>


| Path                | Method | Description                     | Scope   | Matching engine  | Permission       |
|---------------------|-------------|---------------------------------|---------|---------------------|-------------------------------|
| /spot/v1/orders          | POST        | Place new order                 | private | yes                 | read,spot trade                    |
| /spot/v1/cancel_orders   | POST        | Cancel order                    | private | yes                 | read,spot trade                    |
| /spot/v1/amend_orders    | POST        | Amend order                     | private | yes                 | read,spot trade                    |
| /spot/v1/open_orders     | GET         | Query open orders               | private | no                  | read                          |
| /spot/v1/orders          | GET         | Query order history             | private | no                  | read                          |
| /spot/v1/user/trades     | GET         | Query user trades               | private | no                  | read                          |
| /spot/v1/accounts        | GET         | Query user account information   | private | no                  | read                         |
| /spot/v1/transactions    | GET         | Query transaction logs          | private | no                  | read                          |
| /spot/v1/ws/auth         | GET         | Get websocket access token      | private | no                  | read                          |
| /v1/wallet/spot-withdraw | POST        | New withdrawal request          | private | no                  | wallet                          |
| /v1/wallet/sub-user-transfer | POST    | New transfer request with sub users   | private | no            | wallet                          |
| /v1/wallet/transfer      | POST        | New transfer request            | private | no                  | wallet                          |
| /v1/wallet/sub-user-transfer | GET     | Get transfer hisroty with sub users   | private | no            | read                          |
| /v1/wallet/transfer      | GET         | Get transfer history            | private | no                  | read                          |
| /v1/wallet/spot-withdrawals | GET      | Get withdrawal history          | private | no                  | read                          |
| /v1/wallet/spot-deposits | GET         | Get deposit records             | private | no                  | read                          |
| /spot/v1/system/time     | GET         | Get server time                 | public  | no                  |  |
| /spot/v1/system/version  | GET         | Get system version              | public  | no                  |  |
| /spot/v1/instruments     | GET         | Query instruments               | public  | no                  |   |
| /spot/v1/orderbooks      | GET         | Query orderbook                 | public  | no                  |   |
| /spot/v1/market/trades   | GET         | Query market trades             | public  | no                  |   |
| /spot/v1/klines          | GET         | Query kline data                | public  | no                  |   |
| /spot/v1/tickers         | GET         | Query instrument ticker         | public  | no                  |  |
