# Websocket API

Data subscription is based on Websocket protocol. Users can send subscription requests after established Websocket connections.
Connection will be auto disconnected if no subscription is initiated within 30s.
All the responses will be based on the below return format.


| Name      | Type    | Description                                       |
| :-------- | :------ | :------------------------------------------------ |
| channel   | string  | Channel name                                      |
| timestamp | integer | The timestamp (milliseconds since the Unix epoch) |
| data      | object  | Content                                           |

## Subscription management

> Request

```json
{
    "type":"subscribe",
    "pairs":[
        "BTC-USDT",
    ],
    "channels":[
        "depth",
        "ticker",
        "kline.5",
        "order",
        "account"
    ],
    "interval": "100ms",
    "token":"be4ffcc9-2b2b-4c3e-9d47-68bf062cf651"
}
```

> Response (success)

```json
{
    "channel":"subscription",
    "timestamp":1587921122970,
    "data":{
        "code":0,
        "subscription":[
            "depth",
            "ticker",
            "kline.5"
        ]
    }
}
```

> Response (failure)

```json
{
    "channel":"subscription",
    "timestamp":1587921122970,
    "data":{
        "code":13200302,
        "message":"auth failed: invalid token"
    }
}
```

Users can subscribe to different channels, public and private. Private channel requires token and authentication.

Channels have different specifications, see details in the documentations below.

Users can set push frequency via 'interval'. raw = push when there is a change, 100ms = push if any change in the last 100ms

If the subscription request contains more than one channel and one of them failed, you will receive two separate responses.

Users can stop the feed by submitting an unsubscribe request.


### Parameters

| Name     | Type     | Description                              |
| -------- | -------- | ---------------------------------------- |
| type     | string   | [`subscribe`, `unsubscribe`]             |
| channels | string[] | List of channels                         |
| pairs    | string[] | List of currency pairs                   |
| interval | string   | [`raw`, `100ms`] default value is `raw`  |
| token    | string   | Authentication token for private channel |

### Response

| Name         | Type     | Description                                 |
| :----------- | :------- | :------------------------------------------ |
| code         | integer  | 0 means success, !=0 means failure         |
| message      | string   | Error message, return when failed           |
| subscription | string[] | Subscription list, return when successful   |



## Authentication Token

### GET /spot/v1/ws/auth

> Request


```shell
curl -H "X-Bit-Access-Key: ak-ba3bd026-29e6-443b-8eb6-d2ea3b607113" "https://betaspot-api.bitexch.dev/spot/v1/ws/auth?timestamp=1588996062516&signature=9ed1dd821cc6464d2cfc5bf9614df1f22611c977b513e1ffde864a673b6915f0" 

```

> Response

```json
{
    "code":0,
    "message":"",
    "data":{
        "token":"be4ffcc9-2b2b-4c3e-9d47-68bf062cf651"
    }
}
```

To connect private websocket channels, user needs to first call `GET /spot/v1/ws/auth` to acquire a token,
which will be used to fill in private websocket channel subscription for websocket authentication.

Each token is used for single websocket connection, user needs to acquire new token if reconnect.

For websocket connection, user only need to do authentication in first private channel subscription,
subsequent private subscription do not need authenticate.


### Parameters

*None*

### Response

| Name  | Type   | Description                          |
| ----- | ------ | ------------------------------------ |
| token | string | private channel authentication token |



## Heartbeat



According to [RFC 6455](https://tools.ietf.org/html/rfc6455), Websocket protocol uses PING/PONG to indicate connection is alive.

Server sends PING to client every minute through Websocket, client responds with PONG. Connection will be closed if PONG is not received after one minute.

Client can also send PING to check if the server is still responsive.

PING/PONG are both control frames. PING's opcode is 0x9，PONG's opcode is 0xA. One can refer to this [link](https://tools.ietf.org/html/rfc6455#section-5.5.2)。



## Channel Summary

| Channel                                           | Scope   | Arguments | Description                                      |
| ------------------------------------------------- | ------- | --------- | ------------------------------------------------ |
| [depth](#depth-channel)                           | public  | pairs     | Changes to the order book                        |
| [order_book.{group}.{depth}](#order-book-channel) | public  | pairs     | Order book based on specified group and depth    |
| [depth1](#depth1-channel)                         | public  | pairs     | Top of order book bid/ask                        |
| [ticker](#ticker-channel)                         | public  | pairs     | The most recent traded price and trading summary |
| [kline.{resolution}](#kline-channel)              | public  | pairs     | Kline data                                       |
| [trade](#trade-channel)                           | public  | pairs     | Trades of the specified currency pair            |
| [market_trade](#market-trade-channel)             | public  |           | Trades of all available currency pairs           |
| [account](#account-channel)                       | private |           | User's account information                       |
| [order](#order-channel)                           | private |           | User's order information                         |
| [user_trade](#user-trade-channel)                 | private |           | User's trade information                         |



## Depth Channel

> Request

```json
{
    "type":"subscribe",
    "pairs":[
        "BTC-USDT"
    ],
    "channels":[
        "depth"
    ],
    "interval": "100ms"
}
```

> Response (snapshot)

```json
{
    "channel":"depth",
    "timestamp":1587929552250,
    "data":{
        "type":"snapshot",
        "pair":"BTC-USDT",
        "sequence":9,
        "bids":[
            [
                "0.08000000",
                "0.10000000"
            ]
        ],
        "asks":[
            [
                "0.09000000",
                "0.20000000"
            ]
        ]
    }
}
```

> Response (update)

```json
{
    "channel":"depth",
    "timestamp":1587930311331,
    "data":{
        "type":"update",
        "pair":"BTC-USDT",
        "sequence":10,
        "prev_sequence":9,
        "changes":[
            [
                "sell",
                "0.08500000",
                "0.10000000"
            ]
        ]
    }
}
```

`depth` channel can have two message types: `snapshot` and `update`. Snapshot sends snapshots of the current order book. Updates sends changes of the order book.

The first message will always be a snapshot followed by updates, if there is any sort of disruption, a new snapshot will be sent follow by updates.

A snapshot includes bids and asks depths, each depth layer consists of two elements: price and quantity.

A normal update message contains sequence and prev_sequence, with the prev_sequence matching the previous update.

Changes in update is a result in a change in depth, every changes consists of three elements: [side](#order-side), price and quantity. Quantity=0 means a layer is been removed from the depth.



### Channel Information

| Channel | Scope  | Arguments |
| ------- | ------ | --------- |
| depth   | public | pairs     |

### Response

| Name          | Type                             | Description                                                    |
| :------------ | :------------------------------- | :------------------------------------------------------------- |
| type          | string                           | [`snapshot`, `update`]                                         |
| pair          | string                           | Currency pair                                                  |
| sequence      | integer                          | Order book update sequence                                     |
| asks          | array of [price, quantity]       | Asks, price and quantity are string, return when type=snapshot |
| bids          | array of [price, quantity]       | Bids, price and quantity are string, return when type=snapshot |
| prev_sequence | integer                          | Previous update sequence number, return when type=update       |
| changes       | array of [side, price, quantity] | Depth changes, [side](#order-side)、price、quantity are string, quantity=0 means deletion, return when type = update |



## Order Book Channel

> Request

```json
{
    "type":"subscribe",
    "pairs":[
        "BTC-USDT"
    ],
    "channels":[
        "order_book.10.10"
    ],
    "interval": "100ms"
}
```

> Response

```json
{
    "channel":"order_book.10.10",
    "timestamp":1587930311331,
    "data":{
        "pair":"BTC-USDT",
        "sequence":3,
        "bids":[
            [
                "0.00200000",
                "0.50000000"
            ],
            [
                "0.00100000",
                "0.30000000"
            ]
        ],
        "asks":[
            [
                "0.00300000",
                "0.20000000"
            ]
        ]
    }
}
```

`order_book` pushes certain layers of an order book data based on group and depth.

An order book message includes bids and asks depths, each depth layer consists of two elements: price and quantity.

### Channel Information


| Channel                    | Scope  | Arguments |
| -------------------------- | ------ | --------- |
| order_book.{group}.{depth} | public | pairs     |


When subscribing to orderbook channel, user will need to specify group and depth in channel

* group value: represents the multiple of the order book price steps, aggregation level = `group` * `price_step`. <br>
Valid `group` value of currency pair can be retrieved via the rest api [`/spot/v1/instruments`](#get-currency-pairs).

* depth value: ``1``, ``10``, ``20``, ``100``, represents order book layers

Default is group=1, depth=10

### Order book price aggregation example <br>

Assume price_step = 0.01 <br>

raw depth: <br>
bids: [[0.13, 3], [0.19, 7], [0.26, 5], [0.77, 12.3]]<br>

for orderbook.10.5, aggregation price level = 0.01 * 10 = 0.1<br>
output bids: [[0.1, 10], [0.2, 5], [0.7, 12.3]]<br>






### Response

| Name     | Type                       | Description                         |
| :------- | :------------------------- | :---------------------------------- |
| pair     | string                     | Currency pair                       |
| sequence | integer                    | Order book update sequence          |
| asks     | array of [price, quantity] | Asks, price and quantity are string |
| bids     | array of [price, quantity] | Bids, price and quantity are string |



## Depth1 Channel

> Request

```json
{
    "type":"subscribe",
    "pairs":[
        "BTC-USDT"
    ],
    "channels":[
        "depth1"
    ],
    "interval": "100ms"
}
```

> Response

```json
{
    "channel":"depth1",
    "timestamp":1587932635873,
    "data":{
        "pair":"BTC-USDT",
        "best_ask":"0.08500000",
        "best_ask_qty":"0.10000000",
        "best_bid":"0.08000000",
        "best_bid_qty":"0.10000000",
    }
}
```

`depth1` pushes top of book bid/ask information

### Channel Information


| Channel | Scope  | Arguments |
| ------- | ------ | --------- |
| depth1  | public | pairs     |

### Response

| Name         | Type   | Description                                    |
| :----------- | :----- | :--------------------------------------------- |
| pair         | string | Currency pair                                  |
| best_ask     | string | Best ask price, empty if there aren't any asks |
| best_ask_qty | string | Quantity of best ask                           |
| best_bid     | string | Best bid price, empty if there aren't any bids |
| best_ask_qty | string | Quantity of best bid                           |



## Ticker Channel

> Request

```json
{
    "type":"subscribe",
    "pairs":[
        "BTC-USDT"
    ],
    "channels":[
        "ticker"
    ],
    "interval": "100ms"
}
```

> Response

```json
{
    "channel":"ticker",
    "timestamp":1589126498813,
    "data":{
        "time":1589126498800,
        "pair":"BTC-USDT",
        "best_bid":"50200.50000000",
        "best_ask":"50201.00000000",
        "best_bid_qty":"2.30000000",
        "best_ask_qty":"0.80000000",
        "last_price":"50200.80000000",
        "last_qty":"0.10000000",
        "open24h":"50500.00000000",
        "high24h":"50500.00000000",
        "low24h":"50100.00000000",
        "price_change24h":"-0.00592475",
        "volume24h":"0.10000000",
        "quote_volume24h":"5020.08000000"
    }
}
```

`ticker` pushes the most recent traded price and the last 24 hrs trading summary.

### Channel Information

| Channel | Scope  | Arguments |
| ------- | ------ | --------- |
| ticker  | public | pairs     |

### Response


| Name             | Type    | Description                                          |
| :--------------- | :------ | :--------------------------------------------------- |
| pair             | string  | Currency pair                                        |
| last_price       | string  | Most recent traded price                             |
| last_qty         | string  | Most recent traded volume                            |
| open24h          | string  | Open price during previous 24 hour                   |
| high24h          | string  | Highest price during previous 24 hour                |
| low24h           | string  | Lowest price during previous 24 hour                 |
| volume24h        | string  | Sum volume during previous 24 hour                   |
| quote_volume24h  | string  | Sum quote volume during previous 24 hour             |
| price_change24h  | string  | Price change% during previous 24 hour                |
| best_bid         | string  | Best bid price, empty if there aren't any bids       |
| best_ask         | string  | Best ask price, empty if there aren't any asks       |
| best_bid_qty     | string  | Quantity of best bid                                 |
| best_ask_qty     | string  | Quantity of best ask                                 |
| time             | integer | Ticker timestamp (milliseconds since the Unix epoch) |


## Kline Channel

> Request

```json
{
    "type":"subscribe",
    "pairs":[
        "BTC-USDT"
    ],
    "channels":[
        "kline.5"
    ],
    "interval": "100ms"
}
```

> Response

```json
{
    "channel":"kline.5",
    "timestamp":1587979850118,
    "data":{
        "pair":"BTC-USDT",
        "tick":1587979800000,
        "open":"7737.50000000",
        "low":"7737.50000000",
        "high":"7737.50000000",
        "close":"7737.50000000",
        "volume":"0.00000000"
    }
}
```

`kline` pushed kline data. If there is no trade during the current period, the previous close will be used for open, high and low.

### Channel Information

| Channel            | Scope  | Arguments |
| ------------------ | ------ | --------- |
| kline.{timeframe}  | public | pairs     |



When subscribing to kline channel, user will need to specify timeframe.

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


### Response

| Name   | Type    | Description        |
| :----- | :------ | :----------------- |
| pair   | string  | Currency pair      |
| tick   | integer | Tick starting time |
| open   | string  | Open price         |
| close  | string  | Close price        |
| high   | string  | High price         |
| low    | string  | Low price          |
| volume | string  | Volume             |



## Trade Channel

> Request

```json
{
    "type":"subscribe",
    "pairs":[
        "BTC-USDT"
    ],
    "channels":[
        "trade"
    ],
    "interval": "100ms"
}
```

> Response

```json
{
    "channel":"trade",
    "timestamp":1588997059735,
    "data":[
        {
            "trade_id":"2388418",
            "pair":"BTC-USDT",
            "price":"0.01800000",
            "qty":"0.10000000",
            "side":"buy",
            "created_at":1588997060000
        }
    ]
}
```

`trade` pushes trading information of the specified currency pair 

### Channel Information

| Channel | Scope  | Arguments |
| ------- | ------ | --------- |
| trade   | public | pairs     |

### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>


| Name       | Type    | Description                                         |
| :--------- | :------ | :-------------------------------------------------- |
| pair       | string  | Currency pair                                       |
| trade_id   | string  | Trade ID                                            |
| price      | string  | Price                                               |
| qty        | string  | Quantity                                            |
| side       | string  | Taker trade side                                    |
| created_at | integer | Trade timestamp (milliseconds since the Unix epoch) |



## Market Trade Channel

> Request

```json
{
    "type":"subscribe",
    "channels":[
        "market_trade"
    ],
    "interval": "100ms"
}
```

> Response

```json
{
    "channel":"market_trade",
    "timestamp":1588997059735,
    "data":[
        {
            "trade_id":"2388418",
            "pair":"BTC-USDT",
            "price":"0.01800000",
            "qty":"0.10000000",
            "side":"buy",
            "created_at":1588997060000
        }
    ]
}
```

`market_trade` pushes trading information of all available currency pairs

### Channel Information

| Channel      | Scope  | Arguments |
| ------------ | ------ | --------- |
| market_trade | public |           |

### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>


| Name       | Type    | Description                                         |
| :--------- | :------ | :-------------------------------------------------- |
| pair       | string  | Currency pair                                       |
| trade_id   | string  | Trade ID                                            |
| price      | string  | Price                                               |
| qty        | string  | Quantity                                            |
| side       | string  | Taker trade side                                    |
| created_at | integer | Trade timestamp (milliseconds since the Unix epoch) |



## Account Channel

> Request

```json
{
    "type":"subscribe",
    "channels":[
        "account"
    ],
    "interval": "100ms",
    "token":"6d501ded-3c40-4697-b390-218a54b9de19"
}
```

> Response

```json
{
    "channel":"account",
    "timestamp":1589031930115,
    "data":{
        "user_id": "1001",
        "balances": [
          {
            "currency": "BTC",
            "available":"99.59591877",
            "frozen":"0.00000000"
          }
        ]
    }
}
```

`account` pushes user's account information

### Channel Information

| Channel | Scope   | Arguments  |
| ------- | ------- | ---------- |
| account | private |            |

### Response

| Name     | Type               | Description   |
| :------- | :----------------- | :------------ |
| user_id  | string             | User ID       |
| balances | array of `Balance` | Balance list  |

* Balance object

| Name      | Type   | Description      |
| :-------- | :----- | :--------------- |
| currency  | string | Currency         |
| available | string | Available amount |
| frozen    | string | Frozen amount    |


## Order Channel

> Request

```json
{
    "type":"subscribe",
    "channels":[
        "order"
    ],
    "interval": "100ms",
    "token":"6d501ded-3c40-4697-b390-218a54b9de19"
}
```

> Response

```json
{
    "channel":"order",
    "timestamp":1587994934089,
    "data":[
        {
            "order_id":"1590",
            "created_at":1587870609000,
            "updated_at":1587870609000,
            "user_id":"51140",
            "pair":"BTC-USDT",
            "order_type":"limit",
            "side":"buy",
            "price":"0.16000000",
            "qty":"0.50000000",
            "time_in_force":"gtc",
            "avg_price":"0.16000000",
            "filled_qty":"0.10000000",
            "status":"open",
            "fee":"0.00002000",
            "taker_fee_rate":"0.00050000",
            "maker_fee_rate":"0.00020000",
            "label":"hedge"
        }
    ]
}
```

`order` pushes user's order information

### Channel Information

| Channel | Scope   | Arguments |
| ------- | ------- | --------- |
| order   | private |           |

### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>


| Name             | Type    | Description                                                  |
| :--------------- | :------ | :----------------------------------------------------------- |
| pair             | string  | Currency pair                                                |
| order_id         | string  | Order ID                                                     |
| created_at       | integer | Timestamp at order creation (milliseconds since the Unix epoch) |
| updated_at       | integer | Timestamp at order update (milliseconds since the Unix epoch)   |
| user_id          | string  | User ID                                                      |
| qty              | string  | Quantity                                                     |
| filled_qty       | string  | Filled quantity                                              |
| price            | string  | Order price                                                  |
| avg_price        | string  | Average filled price                                         |
| side             | string  | [Order side](#order-side)                                    |
| order_type       | string  | [Order type](#order-type)                                    |
| time_in_force    | string  | [Order time in force](#order-time-in-force)                  |
| status           | string  | [Order status](#order-status)                                |
| fee              | string  | Fee                                                          |
| taker_fee_rate   | string  | Taker fee rate                                               |
| maker_fee_rate   | string  | Maker fee rate                                               |
| label            | string  | User defined label                                           |



## User Trade Channel

> Request

```json
{
    "type":"subscribe",
    "channels":[
        "user_trade"
    ],
    "interval": "100ms",
    "token":"6d501ded-3c40-4697-b390-218a54b9de19"
}
```

> Response

```json
{
    "channel":"user_trade",
    "timestamp":1588997059737,
    "data":[
        {
            "trade_id":"2388418",
            "order_id":"1384232",
            "pair":"BTC-USDT",
            "qty":"0.10000000",
            "price":"0.01800000",
            "fee":"0.00005000",
            "fee_rate":"0.00050000",
            "side":"buy",
            "created_at":1588997060000,
            "is_taker":true,
            "order_type":"limit"
        }
    ]
}
```

`user_trade` pushes user trade information

### Channel Information

| Channel    | Scope   | Arguments |
| ---------- | ------- | --------- |
| user_trade | private |           |

### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>


| Name        | Type    | Description                                                     |
| :---------- | :------ | :-------------------------------------------------------------- |
| order_id    | string  | Order ID                                                        |
| trade_id    | string  | Trade ID                                                        |
| pair        | string  | Currency pair                                                   |
| order_type  | string  | User [Order type](#order-type)                                  | 
| side        | string  | User [Order side](#order-side)                                  |
| price       | string  | Trade price                                                     |
| qty         | string  | Trade quantity                                                  |
| fee         | string  | Transaction fees                                                |
| fee_rate    | string  | Fee rate                                                        |
| is_taker    | boolean | Is taker or not                                                 |
| created_at  | integer | Timestamp at trade creation (milliseconds since the Unix epoch) |

