# Account

## Get spot accounts

### GET /spot/v1/accounts

```shell

curl -H "X-Bit-Access-Key: ak-ba3bd026-29e6-443b-8eb6-d2ea3b607113" "https://betaspot-api.bitexch.dev/spot/v1/accounts?timestamp=1589521383462&signature=30f7cf5c8018f5dfee515533e25a1813e9120be7898b62fb85a2f4129f3e9528"

```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": {
        "user_id": "1001",
        "balances": [
          {
            "currency": "BTC",
            "free":"99.59591877",
            "locked":"0.00000000"
          }
        ]
    }
}
```

Get user account information.


### Query parameters

None

### Response

Name | Type | Desc
---- | ---- | ----
user_id | string | User id
balances | array | Balance list

* Balance object

Name | Type | Desc
---- | ---- | ----
currency | string | Currency
available | string | Available amount
frozen | string | Frozen amount

---


## Get user transactions

### GET /spot/v1/transactions

```shell
curl -H "X-Bit-Access-Key: ak-8e97ac6c-8075-4a94-b2bb-38bd537619fa" "https://betaspot-api.bitexch.dev/spot/v1/transactions?currency=BTC&type=trade-recv&limit=2&timestamp=1620369292928&signature=35d76033f6e251ce85524ec4310417fd555953fff00cd33f3a94e3d27d062965" 


```

> Response

```json
{
    "code": 0,
    "message": "",
    "data": [
        {
            "tx_time": 1619688616411,
            "ccy": "BTC",
            "tx_type": "trade-recv",
            "change": "0.09970000",
            "balance": "0.99700000",
            "fee_paid": "0.00030000",
            "trade_id": "557364",
            "order_id": "236142",
            "pair": "BTC-USDT",
            "order_side": "buy",
            "remark": ""
        },
        {
            "tx_time": 1619688616411,
            "ccy": "BTC",
            "tx_type": "trade-recv",
            "change": "0.09970000",
            "balance": "0.89730000",
            "fee_paid": "0.00030000",
            "trade_id": "557363",
            "order_id": "236142",
            "pair": "BTC-USDT",
            "order_side": "buy",
            "remark": ""
        }
    ],
    "page_info": {
        "has_more": true
    }
}
```

Get user transactions.


### Query Parameters
Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
currency  | string  | true     | ""   | Currency
start_time  | integer  | false     |  0  | Start timestamp
end_time  | integer | false     |  0  | End timestamp
type | string | false | "" | [Transaction type](#transaction-log-type)
offset  | int | false   | 1   | Page index, first page = 1
limit   | int | false   | 100 | Page size


### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>

Name | Type | Desc
---- | ---- | ----
tx_time | integer | Transaction time
ccy | string | Currency
tx_type | string | [Transaction type](#transaction-log-type)
change | string | Change
balance | string | Balance after change
fee_paid | string | Fee paid
order_id | string | Order ID
trade_id | string | Trade ID
pair | string | Currency pair
order_side | string | [Order side](#order-side)
remark | string | Remark

--- 