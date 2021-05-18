# Errors

## Error Handling
### A clarification of bit.com trading APIs:

<br>
<aside class="warning">
Be aware of special handling of json error code 18500000 - RPC Timeout, see below.
</aside>

When calling the trading APIs of bit.com to, e.g. placing, editing, cancelling orders, the caller will get one of the following four types of results:<br>
<ol>
<li>A response indicating the request was successful</li>
<li>A response indicating the request had been rejected</li>
<li>A response indicating failed to get the processing result of the request</li>
<li>Failed to receive a response (should be handled similarly to type 3, see below)</li>
</ol>

A result of type 3. happens when the frontend web servers of bit.com failed to receive a response from the matching engine in time (due to a network issue or a timeout). The response can be in the form of<br>
<ol>
<li type="A">A HTTP response with status "504 - Gateway Timeout", when the failure was at the gateway layer.</li>
<li type="A">A HTTP response with status "200 - OK", but the JSON error code = `18500000` (Rpc timeout)</li>
<li type="A">Other forms of network errors if the failure was even before the gateway of bit.com.</li>
</ol>

When a result of type 3 happens, it is unknown to the caller whether the sent request has been received/processed/rejected by the matching engine. Therefore, `the caller has to make another call  checking the state of the order or the account to find out.`


## Error code list

Bit.com API error codes:


Error Code | Description
---------- | -------
0 | Success (no error)
18100100 | General Error
18100101 | Invalid Order Request
18100102 | Invalid Order Side
18100103 | Invalid Order Price
18100104 | Invalid Order Quantity
18100105 | Invalid Order Type
18100106 | Invalid Time In Force
18100107 | Get Position Error
18100109 | Get Underlying Price Fail
18100110 | Place Order Error
18100111 | Marshal Order Error
18100112 | Submit Order Request Error
18100113 | Invalid Order ID
18100114 | Get Order Error
18100115 | Order Not Found
18100116 | Submit Order Cancel Error
18100117 | Invalid Order Status Parameter
18100119 | Get Trade Error
18100131 | Bad Transfer Request
18100132 | Invalid Transfer Quantity
18100133 | Create Transfer Error
18100134 | Get User Trade Error
18100135 | Get Transfer Error
18100137 | Get Account Error
18100138 | Get Trades Error
18100143 | Get Ticks Error
18100146 | Update Account Error
18100147 | Get Transaction Log Error
18100148 | Audit Account Error
18100149 | Delivery Information Error
18100150 | Exceed Max Open Order By Account
18100151 | Exceed Max Open Order By Instrument
18100152 | Get Open Order Count Error
18100154 | Update Access Token Error
18100157 | Bad Config Error
18100158 | Update Config Error
18100159 | Get Fee Rate Error
18100160 | Invalidate Parameters Error
18100161 | Get Orderbook Error
18100162 | Get Index Error
18100163 | Big Account Information Error
18100164 | Get Uc Transfer Record Error
18100165 | Invalid User Error
18100166 | Insurance Account Error
18100167 | Insurance Log Error
18100168 | Fee Account Error
18100169 | Fee Log Error
18100170 | Get Delivery Error
18100171 | Get Insurance Data Error
18100172 | Invalid Depth Error
18100173 | Invalid Expired Error
18100174 | Get Orderbook Summary Error
18100175 | Get Settlement Error
18100176 | Get Trading View Data Error
18100177 | Get User Error
18100178 | Save User Error
18100180 | Invalid Order Cancel Request
18100181 | Get Instrument Error
18100185 | Invalid Instrument
18100186 | Close Position Request Error
18100187 | Get Order Margin Error
18100188 | Get Limit Price Error
18100189 | Invalid Stop Price
18100190 | Get Open Stop Order Count Error
18100191 | Exceed Max Open Stop Order
18100192 | Invalid Order Stop Price
18100193 | Invalid Order Trigger Type
18100194 | Save Stop Order Failed
18100199 | Insufficient Balance Error
18100200 | Invalid Transaction Type Error
18100201 | Get Index Data Error
18100202 | Invalid Argument Error
18100204 | Invalid Page Parameter Error
18100205 | Get Market Summary Error
18100206 | System Account Error
18100210 | Invalid Operator Id Error
18100211 | Get Takeover Records Error
18100212 | Invalid Operator User Ids
18100213 | Start Takeover
18100214 | Invalid Account Id
18100215 | Exit Admin Takeover
18100216 | Link Admin To Account
18100217 | Unlink Admin From Account
18100218 | Calc Portfolio Margin
18100223 | Get Takeover Orders Error
18100224 | Invalid Amend Order Request Error
18100225 | Auto Price Error
18100226 | Takeover Switch User Id Error
18100227 | Account Is Locked Error
18100228 | Get Bankruptcy Error
18100229 | Filled Bankruptcy Request Error
18100230 | Exceed Max Stop Order Error
18100231 | Invalid Stop Order Status Error
18100232 | Verification Code Mail Error
18100233 | Verification Code Phone Error
18100234 | Rpc Error: Order not active
18100235 | Fill Bankruptcy Error
18100236 | Invalid Order Role
18100237 | No Block Order Permission
18100238 | Self Trading Error
18100239 | Illegal Valid Time Error
18100240 | Invalid Block Order Request
18100241 | Accept Block Order Error
18100242 | Reject Block Order Error
18100244 | Reduce Only Error
18100245 | Block Trade Service Stop Error
18100246 | Get Stop Trigger Price Error
18100247 | Get Open Order Size Error
18100248 | Get Position Size Error
18100253 | Get Bonus Error
18100254 | Marketing Refund Request Error
18100255 | Refund Error
18100256 | Get Active Error
18100257 | Get Account Configuration Error
18100258 | Invalid User Kyc Level Error
18100259 | Duplicate Bonus Error
18100260 | Calc Position Summary Error
18100261 | Exceed Account Delta Error
18100262 | Withdraw Request Error
18100263 | Withdraw Error
18100264 | Invalid User Defined String
18100265 | Invalid Blocktrade Source
18100266 | Send Captcha Error
18100267 | Invalid Captcha Error
18100268 | Invalid Number String
18100269 | Exceed Max Position Error
18100270 | Exceed Max Open Quantity Error
18100271 | Get Block Order Error
18100272 | Duplicated Blocktrade Key
18100273 | Creat Bonus Active Error
18100274 | Bonus Total Limit Error
18100275 | Invalid Batch Order Request
18100276 | Invalid Batch Order Count Request
18100277 | Rpc New Batch Order Error
18100278 | Fetch Db Timeout
18100279 | Takeover Not Allowed
18100280 | Invalid Batch Order Amend Request
18100281 | Not Found In Open Orders
18100282 | Rpc Batch Amend Error
18100285 | Mmp error
18100304 | Invalid Channel Error
18100305 | Invalid Category Error
18100306 | Invalid Interval Error
18100401 | Invalid Address
18100402 | Address Not Whitelisted
18100403 | Invalid Fund Password
18100404 | Withdrawal Order Not Exist
18100405 | KYT Rejected
18100406 | Withdraw Too Frequently
18100407 | Withdraw Limit Exceeded
18100408 | Withdraw Amount Less Than Minimum Amount
18200300 | Rate Limit Exceed
18200301 | Login Error
18200302 | Authentication Error, auth code: <br>17002012: no permission to access this endpoint <br>17002011: invalid IP address <br>17002010: signature error <br>17002014: timestamp expired  <br>17002006: internal error
18200303 | Exceed Max Connection Error
18300300 | Not Part In Competition
18300301 | Register Competition Failed
18300302 | Registered Competition
18400300 | Cancel Only Period
18500000 | Rpc timeout error (API result in uncertain state, see above info)