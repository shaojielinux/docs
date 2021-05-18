# Wallet
Bit.com has three types of account: spot account, derivative account and balance account. The three accounts can transfer to each other via API. Spot and derivative account surpport withdrawal via API. 
Sub user can't transfer and withdraw via API.

## Withdraw

### POST /v1/wallet/spot-withdraw

```shell
curl -X POST "https://betaapi.bitexch.dev/v1/wallet/spot-withdraw" -H "Content-Type: application/json" -H "X-Bit-Access-Key: Your Access Key" -d '{"currency": "BTC", "address": "Your address", "amount": "1.2", "pwd": "Your password", "timestamp": 1589523989378, "signature": "signature"}'
```

> Response

```json

{
    "code": 0,
    "message": "",
    "data": {
        "withdraw_id": "b61c2b93-8a25-44d4-9715-023cce61dc50"
    }
}

```

This endpoint means withdraw cash from spot account.
Withdraw address need to be whitelisted first here: https://www.bit.com/propertyCenter/withdraw
<br>Password need to be encoded to base64(sha256(pwd)). For example, if password is 123456, the encoded password will be:jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=

### Query Parameter

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
currency | string | true | "" | Currency, BTC
address | string | true | "" | Withdrawal address
amount | string | true | "" | Withdrawal amount
pwd | string | true | "" | Fund password
chain | string | false | "" | ETH for USDTERC, TRX for USDTTRC

### Response

Name | Type | Description
---- | ---- | ----
withdraw_id | string | Withdraw ID, can be used in later inquires 

---


## Withdrawal history

### GET /v1/wallet/spot-withdrawals

```shell
curl -H "X-Bit-Access-Key: Your Access Key" "https://betaapi.bitexch.dev/v1/wallet/spot-withdrawals?currency=BTC&limit=10&offset=0&timestamp=1589522687689&signature=signature"
```

> Response

```json

{
	"code": 0,
	"data": {
		"count": 2,
		"items": [{
			"address": "mfaFpdVCb6UFS5AXUhC8VGXgj9dnJ37nLP",
			"amount": "0.001",
			"code": 0,
			"confirmations": 0,
			"currency": "BTC",
			"fee": "0.00001",
			"state": "confirmed",
			"transaction_id": "52e1537002f51acbf5f52b9dfeab6a9e7cc185a669cda2573e768420b0839523",
			"created_at": 1608606000000,
			"updated_at": 1608606000000,
			"is_onchain": true
		}, {
			"address": "mfaFpdVCb6UFS5AXUhC8VGXgj9dnJ37nLP",
			"amount": "0.11",
			"code": 13100100,
			"confirmations": 0,
			"currency": "BTC",
			"fee": "0.00001",
			"state": "rejected",
			"transaction_id": "",
			"created_at": 1608606000000,
			"updated_at": 1608606000000,
			"is_onchain": false
		}]
	}
}
```

Retrieves the withdrawal records of spot account.

### Query parameters

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
currency | String | true | "" | Currency
limit | int | false | 10 | Number of requested items, Max - 50
offset | int | false | 0 | the offset for pagination
withdraw_id | string | false | "" | withdraw order id

### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>

Name | Type | Description
---- | ---- | ----
code | int | Withdraw ID error code, 0 means normal, rest means failed
state | string | [withdrawal state](#constant-definitions)
address | string | Withdraw address
amount | string | Withdraw amount
confirmations | int | Confirmation counts, 0 for internal transfers since they are offchain 
currency | string | Currency
fee | string | Withdraw fee
transaction_id | string | Transaction hash
created_at | int | Timestamp of the order created
updated_at | int | Timestamp of the order updated
is_onchain | bool | Whether the order is onchain

## Deposits history

### GET /v1/wallet/spot-deposits

```shell
curl -H "X-Bit-Access-Key: Your Access Key" "https://betaapi.bitexch.dev/v1/wallet/spot-deposits?currency=BTC&limit=10&offset=0&timestamp=1589522687689&signature=signature"
```

> Response

```json

{
	"code": 0,
	"data": {
		"count": 1,
		"items": [{
			"address": "mfaFpdVCb6UFS5AXUhC8VGXgj9dnJ37nLP",
			"amount": "0.001",
			"code": 0,
			"confirmations": 0,
			"currency": "BTC",
			"state": "confirmed",
			"transaction_id": "52e1537002f51acbf5f52b9dfeab6a9e7cc185a669cda2573e768420b0839523",
			"created_at": 1608606000000,
			"updated_at": 1608606000000,
			"is_onchain": true
		}]
	}
}
```

Retrieves the deposit records of spot account.

### Query parameters

Parameter | Type    | Required | Default | Description
--------- | ------- | -------- | ------- | -----------
currency | String | true | "" | Currency
limit | int | false | 10 | Number of requested items, Max - 50
offset | int | false | 0 | the offset for pagination

### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>

Name | Type | Description
---- | ---- | ----
code | int | Deposit error code, 0 means normal, rest means failed
state | string | [deposit state](#constant-definitions)
address | string | Deposit address
amount | string | Deposit amount
confirmations | int | Confirmation counts, 0 for internal transfers since they are offchain 
currency | string | Currency
transaction_id | string | Transaction hash
created_at | int | Timestamp of the order created
updated_at | int | Timestamp of the order updated
is_onchain | bool | Whether the order is onchain

## Transfer

### POST /v1/wallet/transfer

```shell
curl -X POST "https://betaapi.bitexch.dev/v1/wallet/transfer" -H "Content-Type: application/json" -H "X-Bit-Access-Key: Your Access Key" -d '{"currency": "BTC", "amount": "1.2", "type": 1, "timestamp": 1589523989378, "signature": "signature"}'
```

> Response

```json

{
    "code": 0,
    "message": ""
}
```

 Bit.com has three types of account: spot account, derivative account and balance account. The three accounts can transfer to each other.

### Post json body


| Parameter | Type   | Required | Default | Description                                                 |
|-----------|--------|----------|---------|-------------------------------------------------------------|
| currency  | string | true     |         | Currency, e.g. BTC                                          |
| amount    | string | true     |         | Transfer amount                                             |
| type      | int | true     |         | Transfer type, 1: spot-to-derivative, 2: derivative-to-spot, 3: spot-to-balance, 4: balance-to-spot, 5: derivative-to-balance, 6: balance-to-derivative |


## Transfer history

### GET /v1/wallet/transfer

```shell
curl -H "X-Bit-Access-Key: Your Access Key" "https://betaapi.bitexch.dev/v1/wallet/transfer?currency=BTC&count=10&offset=0&timestamp=1589522687689&signature=signature"
```

> Response

```json

{
	"code": 0,
	"data": {
		"count": 2,
		"items": [{
			"status": "done",
			"currency": "BTC",
			"amount": "1.2",
			"type": 1,
			"created_at": 1608606000000,
			"id": "123"
		}, {
			"status": "done",
			"currency": "ETH",
			"amount": "1.2",
			"type": 2,
			"created_at": 1608606000000,
			"id": "124"
		}]
	}
}
```

### Query parameters

| Parameter | Type   | Required | Default | Description                                  |
|-----------|--------|----------|---------|----------------------------------------------|
| currency  | string | false    |         |                                              |
| limit     | int    | false    | 10      | Number of requested items, Max - 50          |
| offset    | int    | false    | 1       | the offset for pagination                    |

### Response

<aside class="notice">
  Returns an <b>array</b>
</aside>


| Name       | Type   | Description                          |
|------------|--------|--------------------------------------|
| status     | string | Transfer status, failed/done/dealing |
| type       | int    | 1: spot-to-derivative, 2: derivative-to-spot, 3: spot-to-balance, 4: balance-to-spot, 5: derivative-to-balance, 6: balance-to-derivative |
| currency   | string |                                      |
| amount     | string |                                      |
| created_at | int    | Timestamp of the order created       |
| order_id | string | transfer id |



