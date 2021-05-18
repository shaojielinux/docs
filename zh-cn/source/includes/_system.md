# System

## Get server timestamp

### GET /spot/v1/system/time

```shell
curl "https://betaspot-api.bitexch.dev/v1/system/time"
```

> Response

```json
{
  "code": 0,
  "message": "",
  "data": 1587884283175
}
```

Get server timestamp


### Query Parameters

None

### Response

Name | Type | Description
---- | ---- | ----
data | string | Server timestamp

---

## Get system version

### GET /spot/v1/system/version

```shell
curl "https://betaspot-api.bitexch.dev/v1/system/version"
```

> Response

```json
{
  "code": 0,
  "message": "",
  "data": "v1.0"
}
```

Get API version

### Query Parameters

None

### Response

Name | Type | Description
---- | ---- | ----
data | string | Api server version


---
