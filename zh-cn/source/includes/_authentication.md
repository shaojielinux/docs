# Authentication

## Private API mandatory fields
* User must put `Access Key` in http request header `X-Bit-Access-Key`.
* User must add `timestamp` (epoch in millisecond) field in request parameter (query string for GET, json body for POST),API server will check this timestamp, if `abs(server_timestamp - request_timestamp) > 5000`, the request will be rejected.
* `timestamp` must be integer, not quoted string.
* User must add `signature` field in request parameter (query string for GET, json body for POST).
* For POST request, Header `Content-Type` should be set as `application/json`.


If authentication fails, a prompt will be returned: “AkId is invalid” and http status code is 412

## Signature algorithm

`Same as derivative API`

```python
    #########
    # Python code to calc BIT.COM API signature
    #########
    import hashlib
    import hmac

    def encode_list(self, item_list):
        list_val = []
        for item in item_list:
            obj_val = self.encode_object(item)
            list_val.append(obj_val)
        output = '&'.join(list_val)
        output = '[' + output + ']'
        return output

    def encode_object(self, param_map):
        sorted_keys = sorted(param_map.keys())
        ret_list = []
        for key in sorted_keys:
            val = param_map[key]
            if isinstance(val, list):
                list_val = self.encode_list(val)
                ret_list.append(f'{key}={list_val}')
            elif isinstance(val, dict):
                # call encode_object recursively
                dict_val = self.encode_object(val)
                ret_list.append(f'{key}={dict_val}')
            elif isinstance(val, bool):
                bool_val = str(val).lower()
                ret_list.append(f'{key}={bool_val}')
            else:
                general_val = str(val)
                ret_list.append(f'{key}={general_val}')

        sorted_list = sorted(ret_list)
        output = '&'.join(sorted_list)
        return output

    def get_signature(self, http_method, api_path, param_map):
        str_to_sign = api_path + '&' + self.encode_object(param_map)
        print('str_to_sign = ' + str_to_sign)
        sig = hmac.new(self.secret_key.encode('utf-8'), str_to_sign.encode('utf-8'), digestmod=hashlib.sha256).hexdigest()
        return sig

    #########
    # END
    #########

```

1. Request parameters: JSON Body for POST,  query string for the rest
2. Encode string to sign, for simple json object, sort your parameter keys alphabetically, and join them with '&' like 'param1=value1&param2=value2', then get str_to_sign = api_path + '&' + 'param1=value1&param2=value2'
3. For nested array objects, encode each object and sort them alphabetically, join them with '&' and embraced with '[', ']', e.g. 
str_to_sign = api_path + '&' + 'param1=value1&array_key1=[array_item1&array_item2]', see example below.
4. Signature = hex(hmac_sha256(str_to_sign, secret_key))
5. Add `signature` field to request parameter:    
for query string, add '&signature=YOUR_SIGNATURE'
for JSON body, add {'signature':YOUR_SIGNATURE}


<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

### Example for `GET` request
Secret Key: `eabc3108-dd2b-43df-a98d-3e2054049b73`  
HTTP method: GET    
API Path: /v1/margins  
Query string: `price=8000&qty=30&instrument_id=BTC-PERPETUAL&timestamp=1588242614000`  

Then str_to_sign = `/v1/margins&instrument_id=BTC-PERPETUAL&price=8000&qty=30&timestamp=1588242614000`  

```bash
> echo -n "/v1/margins&instrument_id=BTC-PERPETUAL&price=8000&qty=30&timestamp=1588242614000" | openssl dgst -sha256 -hmac "eabc3108-dd2b-43df-a98d-3e2054049b73"

> e3be96fdd18b5178b30711e16d13db406e0bfba089f418cf5a2cdef94f4fb57d
```
sig = hex(hmac_sha256(str_to_sign, secret_key)) = e3be96fdd18b5178b30711e16d13db406e0bfba089f418cf5a2cdef94f4fb57d

Final query string: `price=8000&qty=30&instrument_id=BTC-PERPETUAL&timestamp=1588242614000&signature=e3be96fdd18b5178b30711e16d13db406e0bfba089f418cf5a2cdef94f4fb57d`



### Example for `POST` request
Secret Key: `eabc3108-dd2b-43df-a98d-3e2054049b73`  
HTTP Method: POST  
API Path: /v1/orders  
JSON body:  
`
{
    "instrument_id": "BTC-27MAR20-9000-C",  
    "order_type": "limit",  
    "price": "0.021",  
    "qty": "3.14",  
    "side": "buy",
    "time_in_force": "gtc",  
    "stop_price": "",  
    "stop_price_trigger": "",  
    "auto_price": "",  
    "auto_price_type": "",  
    "timestamp": 1588242614000  
}
`

Then str_to_sign = `/v1/orders&auto_price=&auto_price_type=&instrument_id=BTC-27MAR20-9000-C&order_type=limit&price=0.021&qty=3.14&side=buy&stop_price=&stop_price_trigger=&time_in_force=gtc&timestamp=1588242614000`

```bash
> echo -n "/v1/orders&auto_price=&auto_price_type=&instrument_id=BTC-27MAR20-9000-C&order_type=limit&price=0.021&qty=3.14&side=buy&stop_price=&stop_price_trigger=&time_in_force=gtc&timestamp=1588242614000" | openssl dgst -sha256 -hmac "eabc3108-dd2b-43df-a98d-3e2054049b73"

> 34d9afa68830a4b09c275f405d8833cd1c3af3e94a9572da75f7a563af1ca817
```

sig = hex(hmac_sha256(str_to_sign, secret_key)) = 34d9afa68830a4b09c275f405d8833cd1c3af3e94a9572da75f7a563af1ca817

Final JSON body:  
`
{
    "instrument_id": "BTC-27MAR20-9000-C",
    "order_type": "limit",
    "price": "0.021",
    "qty": "3.14",
    "side": "buy",
    "time_in_force": "gtc",
    "stop_price": "",
    "stop_price_trigger": "",
    "auto_price": "",
    "auto_price_type": "",
    "timestamp": 1588242614000,
    "signature": "34d9afa68830a4b09c275f405d8833cd1c3af3e94a9572da75f7a563af1ca817"
}
`

## POST request json body with boolean field

For example, When calling POST /v1/orders with boolean fields:

Take post_only as example,

* In json body, use following format, a real json boolean field, no quoted string:
{"post_only": true}

* In string payload before making signature:
post_only=true


Example

### request
* `curl -X POST "https://betaapi.bitexch.dev/v1/orders" -H "Content-Type: application/json" -H "X-Bit-Access-Key: ak-df074cbc-dbf7-46f9-b07c-f4f51763ac7a"  -d '{"instrument_id": "BTC-26JUN20-3500-P", "price": "15", "qty": "1", "side": "sell", "time_in_force": "gtc", "order_type": "limit", "post_only": true, "timestamp": 1592587664652, "signature": "cf2d8fe95b71764056a4f707e2388ce84a82ed2915cbe92b58f37c26ea0eda97"}'`

### string to sign
* str_to_sign = /v1/orders&instrument_id=BTC-26JUN20-3500-P&order_type=limit&post_only=true&price=15&qty=1&side=sell&time_in_force=gtc&timestamp=1592587664652

## POST request json body with array field

* Algo

`for item in object_array:` <br>
&ensp;&ensp;&ensp;&ensp;`str_list.add(encode(item))` <br>
`str_to_sign = '&'.join(str_list)` <br>

For example, When calling POST /v1/blocktrades with array fields:

Take trades as example,

* In json body, use following format
{"trades": [{"instrument_id": "BTC-25SEP20-9000-C", "price": "0.21", "qty": "50", "side": "sell"}, {"instrument_id": "BTC-PERPETUAL", "price": "9000", "qty": "500000", "side": "buy"}]}

And secret key is eabc3108-dd2b-43df-a98d-3e2054049b73

Example

### request
* `curl -X POST "https://betaapi.bitexch.dev/v1/trades" -H "Content-Type: application/json" -H "X-Bit-Access-Key: ak-df074cbc-dbf7-46f9-b07c-f4f51763ac7a"  -d '{"label": "A0627-1", "role": "taker", "trades": [{"instrument_id": "BTC-25SEP20-9000-C", "price": "0.21", "qty": "50", "side": "sell"}, {"instrument_id": "BTC-PERPETUAL", "price": "9000", "qty": "500000", "side": "buy"}], "timestamp": 1593239722621, "signature": "9636f1850e33557c03a499bb5c1aed9a36be340f3dbfd22a3f066438b3987d6b"}'`

### string to sign
* str_to_sign = /v1/trades&label=A0627-1&role=taker&timestamp=1593239722621&trades=[instrument_id=BTC-25SEP20-9000-C&price=0.21&qty=50&side=sell&instrument_id=BTC-PERPETUAL&price=9000&qty=500000&side=buy]