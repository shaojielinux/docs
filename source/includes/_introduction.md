# Introduction

Welcome to bit.com API. You can retrieve market data, execute trades and manage your bit.com account through bit.com API.

The document consists of three parts: table of contents for easy browsing (left), longer explanation of each API interface although they are quite self-explanatory already(middle), and example code (right)

How to contact us:  

WEB: www.bit.com  
support team: support@bit.com <br>
VIP server: vip@bit.com <br>
Telegram:https://t.me/bitcom_exchange
<br>

## Market maker projects
<br>Market makers are welcome to participate in bit long-term market making projects.
<br>Send the following information to: vip@bit.com
<br>1. Bit account information;
<br>2. Effective contact information except email;
<br>The type of market maker to be applied for should be indicated in the email (multiple choices are allowed)
<br>Application of market maker for bit spot 
<br>Application of market maker for bit delivery contract
<br>Application of market maker for bit perpetual contract 
<br>Application of market maker for bit option contract

<br>To encourage market makers to provide better liquidity for the platform, they can enjoy preferential transaction fees. Specific market making responsibilities and handling charges shall be provided after application.
<br>* Bit owns the final interpretation right of the market maker project.

## User Manual

We currently offer`spot`,`future` and `option` on bit.com.

Two methods to call API are currently offered at bit.com: Rest and Websocket.

* Rest endpoint

REST endpoint consists of public and private APIs, where public API can be called directly without authentication.

Private API, on the other hand, requires API key signature authentication,  Please register, set up API key and related access set ups on API page before kicking off API development. 


Private API access: read,spot trade,future&option trade,wallet,block trade

API types and access details can be viewed API summary.

* Websocket API

Websocket API is based on websocket protocol. Users need to first establish websocket connection, then send request for channel subscriptions, bit.com start pushing data (ever after) afterwards. You can always unsubscribe or disconnect if you change mind (no longer wish to be subscribed)

Subscription consists of public and private channels, where public channel can be subscribed directly without authentication.
Private channel, on the other hand, requires token and authentication.

Channel types and access details can be viewed channel summary.


<!-- ## Spot API hosts (production)
* REST API base url:  https://spot-api.bit.com
* WS API base url: wss://spot-ws.bit.com -->

## Spot API hosts (testnet)
* REST API base url:  https://betaspot-api.bitexch.dev
* WS API base url:  wss://betaspot-ws.bitexch.dev




## Spot API rate limit
In order to ensure the system efficiency, bit.com implements the API rate limits . The public interface implements IP-specified frequency limitation , and the private interface implements user-specified frequency limitation. When a breach happens, a prompt will be returned: “429 too many requests”. The individual API limits can be found on the webpage of the trading center. Users who need to increase the speed limit please contact the support team via vip@bit.com.

* Rest API rate limits:

Public API: 10 requests per second per IP. <br>
Private API(future&option trade): 5 requests per second per user.<br>
Private API(spot trade):10 requests per second per user<br>
Private API(Wallet): 1 request per second per user.<br>
Private API(Others): 5 requests second per user.<br>


About the type of API rate limits, please refer to API summary.

* WebSockets API Rate Limits:


Unlogged users:100 connections per IP <br>
Unlogged users:10 connection requests per second per IP. <br>
Login users: 5 private connections per user. <br>
Connected IP:disconnection triggers when subscription is not established more than 30s. <br>

