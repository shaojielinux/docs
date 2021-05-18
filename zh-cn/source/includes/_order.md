# Order

## Place new order

### POST /spot/v1/orders

```shell

curl -X POST "https://betaspot-api.bitexch.dev/spot/v1/orders" -H "Content-Type: application/json" -H "X-Bit-Access-Key: ak-ba3bd026-29e6-443b-8eb6-d2ea3b607113"  -d '{"pair": "BTC-USDT", "price": "60000", "qty": "3", "side": "buy", "time_in_force": "gtc", "timestamp": 1589523989378, "signature": "68b658eb68f4ce529623bb4505f5c1c6408b37064a9a5f2102d08088e59d917c"}' 


```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": {
        "order_id": "17552314",
        "created_at": 1589523803017,
        "updated_at": 1589523803017,
        "user_id": "51140",
        "pair": "BTC-USDT",
        "order_type": "limit",
        "side": "buy",
        "price": "60000",
        "qty": "3.00000000",
        "quote_qty": "0.00000000",
        "time_in_force": "gtc",
        "avg_price": "0.00000000",
        "filled_qty": "0.00000000",
        "status": "open",
        "taker_fee_rate": "0.00050000",
        "maker_fee_rate": "0.00020000",
        "cancel_reason": "",
        "label":"hedge",
        "source": "api",
        "post_only": false,
        "reject_post_only": false
    }
}
```

`Price logic`: <br>
* market order: price must be empty string <br>
* limit order: price must be a valid num string <br>

`Quantity logic`: <br>
`limit order and sell-market order` use `"qty"` field to specific order size, unit is base_currency (like BTC) <br>
`buy-market order` use `"quote_qty"` field to specific order size, unit is quote_currency (like USDT), it's actually a target trading amount<br><br>
* buy-market order: quote_qty must be non-empty, qty must be empty. take BTC-USDT as example, quote_qty should be USDT amount. <br>
* limit order or sell-market order: qty must be non-empty, quote_qty must be empty <br>
* In order query, quote_qty is only valid for buy-market orders <br>
* For buy-market order, order query returns `filled_qty` in base currency(there is no `filled_quote_qty`), executed amount is `avg_price` * `filled_qty`, the amount maybe less then requested `quote_qty` as market order is executed in `ioc` style. <br>


Market order time in force should be `ioc` <br>

`Fee currency`: <br>
Fee currency is trade result currency, <br>
if you buy BTC-USDT, fee currency is BTC, <br>
if you sell BTC-USDT, fee currency is USDT, <br>

`Boolean fields`: <br>
Json body boolean field should not be quoted in string <br>
* Correct usage: {"post_only": `true`} <br>
* Wrong usage: {"post_only": `"true"`} <br>

<br>
<aside class="notice"> <br>
<b>When Limit order price not matching multiple of price step size:</b> <br>
For buy limit order, limit price will be rounded down to price step size. <br>
For sell limit order, limit price will be rounded up to price step size. <br>
<br>

<b>When qty or quote_qty not matching multiple of qty(quote_qty) step size:</b> <br>
qty or quote_qty will be round down to step size.

</aside>


### Post json body

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
pair  | string  | true     | ""   | pair
qty  | string  | true     | ""   | Order size (limit order or sell-market order)
quote_qty  | string  | true     | ""   | Size in quoted currency used only for buy market order
side  | string  | true     | ""   | [Order side](#order-side)
price  | string  | false     | "0.0"   | Order price, not required for market order
order_type  | string  | false     | "limit"   | [Order type](#order-type)
time_in_force  | string  | false     | "gtc"   | [Time in force](#order-time-in-force)
label  | string  | false     | ""   | User defined label
post_only | bool | false |false | Indicate post only or not
reject_post_only | bool | false | false | Indicate reject post only or not


### Response

Name | Type | Desc
---- | ---- | ----
order_id | string | Order ID
created_at | integer | Create timestamp
updated_at | integer | Update timestamp
user_id | string | User ID
pair | string | pair
order_type | string | [Order type](#order-type)
side | string |  [Order side](#order-side)
price | string | Order price
qty | string | Order quantity
quote_qty | string | Order quote quantity (only for buy-market order)
time_in_force | string | [Time in force](#order-time-in-force)
avg_price | string | Average filled price
filled_qty | string | Filled qty
status | string | [Order status](#order-status)
taker_fee_rate | string | Taker fee rate
maker_fee_rate | string | Maker fee rate
cancel_reason | string | Order cancel reason
label | string | User defined label
post_only | bool | Indicate post only or not
reject_post_only | bool | Indicate reject post only or not
source | string | [Order source](#order-source)


--- 




## Cancel orders

### POST /spot/v1/cancel_orders

```shell

curl -X POST "https://betaspot-api.bitexch.dev/spot/v1/cancel_orders" -H "Content-Type: application/json" -H "X-Bit-Access-Key: ak-ba3bd026-29e6-443b-8eb6-d2ea3b607113"  -d '{"order_id": "44092860", "timestamp": 1590572422557, "signature": "3c8c2271a58e3d11dfbd262a6be40ebdd07e8f394a002db0065068b36bc66d5a"}' 



```

> Response

```json
{
    "code": 0,
    "message": "",
    "data":{
        "num_cancelled": 2,
        "order_ids": [44092860]
    }
}

```

Filters:

* Can only provide one of: order_id/pair/label, or
* Empty filter means cancel all open order by this user 


### Post json body

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
order_id | string | false | "" | Order ID
pair  | string  | false     | ""   | Pair
label | string  | false     | ""   | Order label

### Response

Name | Type | Desc
---- | ---- | ----
num_cancelled | integer | number of order cancelled
order_ids | array | Order id array

--- 


## Amend orders

### POST /spot/v1/amend_orders

```shell

curl -X POST "https://betaspot-api.bitexch.dev/spot/v1/amend_orders" -H "Content-Type: application/json" -H "X-Bit-Access-Key: ak-ba3bd026-29e6-443b-8eb6-d2ea3b607113"  -d '{"order_id": "1206764", "price": "60010", "timestamp": 1590760362688, "signature": "a74dda0f2bdaf1e1587a5e7577a281497cb66607166bd3b7e0cc4c805c750bf1"}' 



```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": {
        "order_id": "1206764",
        "created_at": 1589523803017,
        "updated_at": 1589523803017,
        "user_id": "51140",
        "pair": "BTC-USDT",
        "order_type": "limit",
        "side": "buy",
        "price": "60010",
        "qty": "3.00000000",
        "quote_qty": "0.00000000",
        "time_in_force": "gtc",
        "avg_price": "0.00000000",
        "filled_qty": "0.00000000",
        "status": "open",
        "taker_fee_rate": "0.00050000",
        "maker_fee_rate": "0.00020000",
        "cancel_reason": "",
        "label":"hedge",
        "source": "api",
        "post_only": false,
        "reject_post_only": false
    }
}

```

Amend order. <br>
Order id is required. <br>
Need to provide at least one of: price,qty. <br>

### Post json body

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
order_id | string | true | "" | Order ID
price | string | false | "" | New price of the order
qty | string | false | "" | New quantity of the order

### Response

Name | Type | Desc
---- | ---- | ----
order_id | string | Order ID
created_at | integer | Create timestamp
updated_at | integer | Update timestamp
user_id | string | User ID
pair | string | pair
order_type | string | [Order type](#order-type)
side | string |  [Order side](#order-side)
price | string | Order price
qty | string | Order quantity
quote_qty | string | Order quote quantity (only for buy-market order)
time_in_force | string | [Time in force](#order-time-in-force)
avg_price | string | Average filled price
filled_qty | string | Filled qty
status | string | [Order status](#order-status)
taker_fee_rate | string | Taker fee rate
maker_fee_rate | string | Maker fee rate
cancel_reason | string | Order cancel reason
label | string | User defined label
post_only | bool | Indicate post only or not
reject_post_only | bool | Indicate reject post only or not
source | string | [Order source](#order-source)


---


## Get open orders

### GET /spot/v1/open_orders

```shell
curl -H "X-Bit-Access-Key: ak-ba3bd026-29e6-443b-8eb6-d2ea3b607113" "https://betaspot-api.bitexch.dev/spot/v1/open_orders?pair=BTC-USDT&i&timestamp=1589523178651&signature=2092cebba4f082f9c8718344cdad9bed83950b5fe90b3a875b708898bfd89b20" 


```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": [{
        "order_id": "7718222",
        "created_at": 1589202185000,
        "updated_at": 1589460149000,
        "user_id": "51140",
        "pair": "BTC-USDT",
        "order_type": "limit",
        "side": "buy",
        "price": "60000",
        "qty": "3.00000000",
        "quote_qty": "0.00000000",
        "time_in_force": "gtc",
        "avg_price": "0.00000000",
        "filled_qty": "0.00000000",
        "status": "open",
        "fee": "0.00000000",
        "taker_fee_rate": "0.00050000",
        "maker_fee_rate": "0.00020000",
        "cancel_reason": "",
        "label":"hedge",
        "source": "api",
        "post_only": false,
        "reject_post_only": false
    }]  
}
```

Get user open orders.


### Query parameters

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
pair  | string  | false     | ""   | pair

### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>

Name | Type | Desc
---- | ---- | ----
order_id | string | Order ID
created_at | integer | Create timestamp
updated_at | integer | Update timestamp
user_id | string | User ID
pair | string | pair
order_type | string |  [Order type](#order-type)
side | string | [Order side](#order-side)
price | string | Order price
qty | string | Order quantity
quote_qty | string | Order quote quantity (only for buy-market order)
time_in_force | string | [Time in force](#order-time-in-force)
avg_price | string | Average filled price
filled_qty | string | Filled quantity
status | string | [Order status](#order-status)
fee | string | Transaction fees
taker_fee_rate | string | Taker fee rate
maker_fee_rate | string | Maker fee rate
cancel_reason | string | Order cancel reason
label | string | User defined label
post_only | bool | Indicate post only or not
reject_post_only | bool | Indicate reject post only or not
source | string | [Order source](#order-source)


--- 


## Get orders

### GET /spot/v1/orders

```shell
curl -H "X-Bit-Access-Key: ak-ba3bd026-29e6-443b-8eb6-d2ea3b607113" "https://betaspot-api.bitexch.dev/spot/v1/orders?pair=BTC-USDT&order_id=7718222&start_time=1585270800000&end_time=1589522084000&i&timestamp=1589523178651&signature=2092cebba4f082f9c8718344cdad9bed83950b5fe90b3a875b708898bfd89b20" 


```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": [{
        "order_id": "7718222",
        "created_at": 1589202185000,
        "updated_at": 1589460149000,
        "user_id": "51140",
        "pair": "BTC-USDT",
        "order_type": "limit",
        "side": "buy",
        "price": "60000",
        "qty": "3.00000000",
        "quote_qty": "0.00000000",
        "time_in_force": "gtc",
        "avg_price": "0.00000000",
        "filled_qty": "0.00000000",
        "status": "cancelled",
        "fee": "0.00000000",
        "taker_fee_rate": "0.00050000",
        "maker_fee_rate": "0.00020000",
        "cancel_reason": "",
        "label":"hedge",
        "source": "api",
        "post_only": false,
        "reject_post_only": false
    }],
    "page_info": {
        "has_more": false
    }      
}
```

Get user order history.


### Query parameters

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
pair  | string  | false     | ""   | pair
order_id  | string  | false     | ""   | Order ID
label  | string  | false     | ""   | Order label
start_time  | integer  | false     |    | Start timestamp
end_time  | integer | false     |    | End timestamp
start_id  | integer  | false     |    | Start order id
end_id  | integer | false     |    | End order id
offset  | int | false   | 1   | Page index, first page = 1
limit   | int | false   | 100 | Page size


### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>

Name | Type | Desc
---- | ---- | ----
order_id | string | Order ID
created_at | integer | Create timestamp
updated_at | integer | Update timestamp
user_id | string | User ID
pair | string | pair
order_type | string |  [Order type](#order-type)
side | string | [Order side](#order-side)
price | string | Order price
qty | string | Order quantity
quote_qty | string | Order quote quantity (only for buy-market order)
time_in_force | string | [Time in force](#order-time-in-force)
avg_price | string | Average filled price
filled_qty | string | Filled quantity
status | string | [Order status](#order-status)
fee | string | Transaction fees
taker_fee_rate | string | Taker fee rate
maker_fee_rate | string | Maker fee rate
cancel_reason | string | Order cancel reason
label | string | User defined label
post_only | bool | Indicate post only or not
reject_post_only | bool | Indicate reject post only or not
source | string | [Order source](#order-source)

--- 


## Get user trades

### GET /spot/v1/user/trades

```shell
curl -H "X-Bit-Access-Key: ak-ba3bd026-29e6-443b-8eb6-d2ea3b607113" "https://betaspot-api.bitexch.dev/spot/v1/user/trades?pair==BTC-USDT&order_id=17551020&start_time=1585270800000&end_time=1589522084000&offset=1&limit=10&timestamp=1589523590679&signature=c4788e3a77b6000424b55067f9ba38009b34d12e482b1c80186756857c869bb5" 


```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": [{
        "trade_id": "23210268",
        "order_id": "17551020",
        "pair": "BTC-USDT",
        "qty": "2.00000000",
        "price": "60000",
        "fee": "0.00100000",
        "fee_rate": "0.00050000",
        "side": "buy",
        "created_at": 1589521371000,
        "order_type": "limit",
        "is_taker": true
    }],
    "page_info": {
        "has_more": false
    }    
}
```

Get user trades


### Query parameters

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
pair  | string  | false     | ""   | Currency pair
order_id  | string  | false     | ""   | Order ID
start_time  | integer  | false     |    | Start timestamp
end_time  | integer | false     |    | End timestamp
start_id  | integer  | false     |    | Start Id
end_id  | integer | false     |    | End Id
offset  | int | false   | 1   | Page index, first page = 1
limit   | int | false   | 100 | Page size


### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>

Name | Type | Desc
---- | ---- | ----
order_id | string | Order ID
trade_id | string | Trade ID
pair | string | Currency pair
created_at | integer | Create timestamp
order_type | string | [Order type](#order-type)
side | string | [Order side](#order-side)
price | string | Trade price
qty | string | Trade quantity
fee | string | Transaction fees
fee_rate | string | Fee rate
is_taker | boolean | Is taker or not

--- 
