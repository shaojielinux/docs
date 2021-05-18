# Market


## Get currency pairs

### GET /spot/v1/instruments


```shell
curl "https://betaspot-api.bitexch.dev/spot/v1/instruments"
```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": [
        {
            "pair": "BTC-USDT",
            "base_currency": "BTC",
            "quote_currency": "USDT",
            "price_step": "0.01000000",
            "qty_step": "0.00050000",
            "quote_qty_step": "0.00000001",
            "quote_qty_min": "10.00000000",
            "taker_fee_rate": "0.00300000",
            "maker_fee_rate": "0.00100000",
            "groups":[
                "1",
                "10",
                "100",
                "1000"
            ],
            "group_steps":[
                "0.01000000",
                "0.10000000",
                "1.00000000",
                "10.00000000"
            ]
        },
        {
            "pair": "ETH-BTC",
            "base_currency": "ETH",
            "quote_currency": "BTC",
            "price_step": "0.00000100",
            "qty_step": "0.00500000",
            "quote_qty_step": "0.00000001",
            "quote_qty_min": "10.00000000",
            "taker_fee_rate": "0.00300000",
            "maker_fee_rate": "0.00100000",
            "groups":[
                "1",
                "10",
                "100",
                "1000"
            ],
            "group_steps":[
                "0.00000100",
                "0.00001000",
                "0.00010000",
                "0.00100000"
            ]
        }
    ]
}
```

Get instrument(currency pair) list


### Query parameters

None

### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>

Name | Type | Description
---- | ---- | ----
pair | string | Currency pair
base_currency | string | Base currency
quote_currency | string | Quote currency
price_step | string | Order price should be multiple of price_step
qty_step | string | Order size should be multiple of qty_step
quote_qty_step | string | Buy-market order quote_qty should be multiple of quote_qty_step
quote_qty_min | string | Minimal buy-market order quote_qty (min trading amount)
taker_fee_rate | string | Taker fee rate
maker_fee_rate | string | Maker fee rate
groups | string array | Available `group` values for websocket channel `orderbook.{group}.{depth}`, is an array of no. of price_step, example ["1", "10"]
group_steps | string array | equivalent to `groups` * `price_step`,internal use for UI page only.

---


## Get orderbooks

### GET /spot/v1/orderbooks


```shell
curl "https://betaspot-api.bitexch.dev/spot/v1/orderbooks?pair=BTC-USDT"
```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": {
        "pair": "BTC-USDT",
        "timestamp": 1585299600000,
        "asks": [
            ["60000", "3.00000000"],
            ["60030", "0.70000000"],
            ["60100", "18.00000000"]
        ],
        "bids": [
            ["59992", "0.30000000"],
            ["59990", "2.00000000"],
            ["59987", "5.60000000"]
        ]
    }
}
```

Get orderbook by Currency pair


### Query parameters

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
pair  | string  | true     | ""   | Currency pair
level | int | false | 5 | No. of depth, value range [1,50]

### Response

Name | Type | Description
---- | ---- | ----
pair | string | Currency pair
timestamp | integer | Timestamp
asks | string | Asks array [price, qty]
bids | string | Bids array [price, qty]

--- 


## Get market trades

### GET /spot/v1/market/trades


```shell
curl "https://betaspot-api.bitexch.dev/spot/v1/market/trades?pair=BTC-USDT&start_time=1617243797588&end_time=1617596597588"
```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": [
        {
            "created_at": 1617592997588,
            "trade_id": "7",
            "pair": "BTC-USDT",
            "price": "61030.00000000",
            "qty": "0.02000000",
            "side": "sell"
        }
    ]
}
```

Get market trades.


### Query parameters

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
pair  | string  | true     | ""   | Currency pair
start_time  | integer  | false     |    | Start timestamp
end_time  | integer | false     |    | End timestamp
count   | int | false   | 100 | Result count (default 100, max 500)


### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>

Name | Type | Description
---- | ---- | ----
trade_id | integer | Trade ID
pair | string | Currency pair
created_at | integer | Creation timestamp of the trade
price | string | Price
qty | string | Quantity
side | string | [Order side](#order-side)

--- 



## Get klines

### GET /spot/v1/klines


```shell
curl "https://betaspot-api.bitexch.dev/spot/v1/klines?pair=BTC-USDT&start_time=1585296000000&end_time=1585596000000&timeframe_min=30"
```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": {
        "close": [
            60050
        ],
        "high": [
            60100
        ],
        "low": [
            60008
        ],
        "open": [
            60030
        ],
        "timestamps": [
            1585296000000
        ],
        "volume": [
            310.2
        ]
    }
}
```

Get klines by Currency pair.
klines endpoint returns 6 time series of data: open price array, hight price array, low price array, close price array,
timestamp array of each kline, and volume array. <br>

Support timeframes:

Timeframe | Name Desc
----------| ----------
1         | 1 minute
3         | 3 minute
5         | 5 minute
15        | 15 minute
30        | 30 minute
60        | 60 minute
240       | 240 minute
1d        | daily
1w        | weekly
1m        | monthly

### Query parameters

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
pair  | string  | true     | ""   | Currency pair
start_time  | integer  | true     |    | Start timestamp
end_time  | integer  | true     |    | End timestamp
timeframe_min  | string  | true     | ""   | Timeframes
count   | int | false   | 100 | Result count (default 100, max 1000)


### Response

Name | Type | Description
---- | ---- | ----
open | float array | Open price series
high | float array | High price series
low | float array | Low price series
close | float array | Close price series
timestamps | float array | Timestamp series
volume | float array | Volume series

--- 


## Get tickers

### GET /spot/v1/tickers


```shell
curl "https://betaspot-api.bitexch.dev/spot/v1/tickers?pair=BTC-USDT"
```

> Response

```json
{
    "code": 0,
    "message": "",
    "data":{
        "time":1589126498813,
        "pair":"BTC-USDT",
        "best_bid":"60050.00000000",
        "best_ask":"60020.00000000",
        "best_bid_qty":"13.50000000",
        "best_ask_qty":"21.00000000",
        "last_price":"60030.00000000",
        "last_qty":"30.00000000",
        "open24h":"60040.00000000",
        "high24h":"60100.00000000",
        "low24h":"60000.00000000",
        "price_change24h":"0.03000000",
        "volume24h":"300.00000000",
        "quote_volume24h":"18000000.00000000"
    }

}
```

Get ticker information by Currency pair.


### Query parameters

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
pair  | string  | true     | ""   | Currency pair

### Response

| Name             | Type   | Description                              |
| :--------------- | :----- | :--------------------------------------- |
| pair    | string | Currency pair                            |
| last_price       | string | Most recent traded price                 |
| last_qty         | string | Most recent traded volume                |
| open24h          | string | Open price during previous 24 hour       |
| high24h          | string | Highest price during previous 24 hour    |
| low24h           | string | Lowest price during previous 24 hour     |
| volume24h        | string | Sum volume of base currency during previous 24 hour       |
| quote_volume24h        | string | Sum volume of quote currency during previous 24 hour       |
| price_change24h  | string | Price change% during previous 24 hour    |
| best_bid         | string | Best bid price                           |
| best_ask         | string | Best ask price                           |
| best_bid_qty     | string | Best bid quantity                        |
| best_ask_qty     | string | Best ask quantity                        |

--- 

