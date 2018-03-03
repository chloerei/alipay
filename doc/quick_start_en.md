Quick Start Guide
=================

### [中文](quick_start_cn.md)

## Table of Contents
* [Client Setup](#client-setup)
   * [Ruby](#ruby)
   * [Ruby on Rails](#ruby-on-rails)
* [Create Payment](#create-payment)
   * [Desktop](#desktop)
   * [Mobile](#mobile)
   * [QR Code](#qr-code)
   * [Installment Plan](#installment-plan)
   * [Verify Callback](#verify-callback)
   * [Query Payment Status](#query-payment-status)
* [Stop Payment](#stop-payment)
   * [Close Payment](#close-payment)
   * [Cancel Payment](#cancel-payment)
* [Refund Payment](#refund-payment)
   * [Initiate Refund](#initiate-refund)
   * [Query Refund Status](#query-refund-status)
* [Fund Transfer](#fund-transfer)
   * [Transfer Fund to Customer](#transfer-fund-to-customer)
   * [Query Fund Transfer](#query-fund-transfer)

## Client Setup

**All examples in the quick start guide assume you have properly setup the client.**

### Ruby
```ruby
# put your Alipay credentials here
API_URL: 'https://openapi.alipaydev.com/gateway.do'
APP_ID: '2016000000000000'
APP_PRIVATE_KEY: "-----BEGIN RSA PRIVATE KEY-----\nxkbt...4Wt7tl\n-----END RSA PRIVATE KEY-----\n"
ALIPAY_PUBLIC_KEY: "-----BEGIN PUBLIC KEY-----\nTq43T5...OVUAQb3R\n-----END PUBLIC KEY-----\n"

# set up a client to talk to the Alipay API
@client = Alipay::Client.new(
  url: API_URL,
  app_id: APP_ID,
  app_private_key: APP_PRIVATE_KEY,
  alipay_public_key: ALIPAY_PUBLIC_KEY
)
```

### Ruby on Rails
You can save your Alipay credentials as environment variables or set them up using initializer.

This guide will demonstrate setting up the Alipay client with the `dotenv-rails` gem.

In your Gemfile
```ruby
# Gemfile
gem 'alipay', '~> 0.15.0'
gem 'dotenv-rails', '~> 2.2', '>= 2.2.1'
```
Then run
```bash
$ bundle install
```

Create an .env file
```ruby
# .env
APP_ID=2016000000000000
ALIPAY_API=https://openapi.alipaydev.com/gateway.do
APP_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\nxkbt...4Wt7tl\n-----END RSA PRIVATE KEY-----\n"
ALIPAY_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----\nTq43T5...OVUAQb3R\n-----END PUBLIC KEY-----\n"
```

In your Ruby on Rails application, you can create an Alipay client instance like this:
```ruby
@client = Alipay::Client.new(
  url: ENV['ALIPAY_API'],
  app_id: ENV['APP_ID'],
  app_private_key: ENV['APP_PRIVATE_KEY'],
  alipay_public_key: ENV['ALIPAY_PUBLIC_KEY']
)
```

## Create Payment

### Desktop
#### API Method
```
alipay.trade.page.pay
```
This API method is for creating payment transaction that is suitable for customers using various desktop (PC) environment.

#### Client Method
```ruby
Alipay::Client.page_execute_url
```
This client method will generate a payment URL for redirecting customers to.

#### Example
```ruby
@client.page_execute_url(
  method: 'alipay.trade.page.pay',
  return_url: 'https://mystore.com/orders/20160401000000/return',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: {
   out_trade_no: '20160401000000',
   product_code: 'FAST_INSTANT_TRADE_PAY',
   total_amount: '0.01',
   subject: 'Example #123'
  }.to_json(ascii_only: true)
)
# => 'https://openapi.alipaydev.com/gateway.do?app_id=2016...'
```

#### Notable Parameters
* `return_url` is where Alipay will redirect customers to after a successful payment is made. The redirect
will be sent via a `GET` request. This is an *optional* parameter.
* `notify_url` is where Alipay will send async callbacks to via `POST` request after a successful
payment. This is an *optional* parameter.
* `out_trade_no` is a unique string set by you. It is expected to be in reference to a model ID
in your application. Although it is not a strict requirement.
* `total_amount` should be in decimal form with a maximum scale of 2. For example `5123.99` will
be ￥5,123.99 in text form. `5123.999` is not a valid parameter.

> For a complete list of the available parameters, please refer to the [API documentation](https://docs.open.alipay.com/270/alipay.trade.page.pay/).


### Mobile
#### API Method
```
alipay.trade.wap.pay
```
This API method is for creating payment transaction for customers on a mobile device. It has the ability to transfer the payment process over to the native Alipay application if the application is installed on the customer's device. If not, the customer will be redirected to a mobile HTML version of the payment page.

#### Client Method
```ruby
Alipay::Client.page_execute_url
```
This method will generate a payment URL for redirecting customers to.

#### Example
```ruby
@client.page_execute_url(
  method: 'alipay.trade.wap.pay',
  return_url: 'https://mystore.com/orders/20160401000000/return',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: {
   out_trade_no: '20160401000000',
   product_code: 'QUICK_WAP_WAY',
   total_amount: '0.01',
   subject: 'Example: 456'
   quit_url: 'https://mystore.com/orders/20160401000000/'
  }.to_json(ascii_only: true)
)
# => 'https://openapi.alipaydev.com/gateway.do?app_id=2016...'
```
#### Notebale Parameters
* `quit_url` is where Alipay will redirect customer to if the customer have completed the payment or have exited the payment process. This redirect only applies to the mobile html verison. This is an *optional* parameter.

> For a complete list of the available parameters, please refer to the
[API documentation](https://docs.open.alipay.com/203/107090/).

### QR Code
#### API Method
```
alipay.trade.precreate
```
This API method generates a payment URL that can be transformed into a QR code for customers to scan. A callback will be issued to the defined `notify_url` if payment is successful.

#### Client Method
```ruby
Alipay::Client.execute
```

#### Example
```ruby
# Create a QR code based payment
response = @client.execute(
  method: 'alipay.trade.precreate',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: {
    out_trade_no: '20160401000000',
    total_amount: '50.00',
    subject: 'QR Code Test'
  }.to_json(ascii_only: true)
)
# => '{\"alipay_trade_precreate_response\":{\"code\"...'

# Get payment url to render as QR code for customer
qr_code = JSON.parse(response)["alipay_trade_precreate_response"]["qr_code"]
# => 'https://qr.alipay.com/abcdefggfedcba'
```

> For a complete list of the available parameters, please refer to the [API documentation](https://docs.open.alipay.com/api_1/alipay.trade.precreate).

### Installment Plan
#### API Methods
```
alipay.trade.page.pay  (Desktop / PC)
alipay.trade.wap.pay  (Mobile)
alipay.trade.precreate  (QR Code)
```

#### Client Method
```ruby
Alipay::Client.page_execute_url  (Desktop / PC / Mobile)
Alipay::Client.execute  (QR Code)
```

#### Example
Scenario: Customer pre-select a six-installment payment plan before going through the payment process at Alipay.

```ruby
@client.page_execute_url(
  method: 'alipay.trade.page.pay',
  return_url: 'https://mystore.com/orders/20160401000000/return',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: {
   out_trade_no: '20160401000000',
   product_code: 'FAST_INSTANT_TRADE_PAY',
   total_amount: '0.01',
   subject: 'Example #654',
   enable_pay_channels: 'balance,pcreditpayInstallment',
   extend_params: {
     hb_fq_num: '6'',
     hb_fq_seller_percent: '0'
   }
  }.to_json(ascii_only: true)
)
```
Scenario: Customer select an installment plan or their choice at Alipay's payment page.
```ruby
@client.page_execute_url(
  method: 'alipay.trade.page.pay',
  return_url: 'https://mystore.com/orders/20160401000000/return',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: {
   out_trade_no: '20160401000000',
   product_code: 'FAST_INSTANT_TRADE_PAY',
   total_amount: '0.01',
   subject: 'Example #654',
   enable_pay_channels: 'balance,pcreditpayInstallment',
  }.to_json(ascii_only: true)
)
```
#### Notebale Parameters
* `enable_pay_channels` defines the funding methods that the customer can use to
pay for your order. `pcreditpayInstallment` is the value to enable installment plans. Mutiple
values can be enabled by sperating the values by `,` like the example above.
* `hb_fq_num` defines the number of installments. Valid values are `3`, `6`, or `12`.
* `hb_fq_seller_percent` defines the percentage of credit installment fee the seller is
responsiable for. Valid value is `0` where the customer bare all the fees. Another valid value is
`100` where you bare all the fees. However it only becomes valid if you have a special contract
signed with Alipay.

> For a complete list of the available parameters, please refer to the [API documentation](https://docs.open.alipay.com/277/106748/).


### Verify Callback
#### Client Method
```
Alipay::Client.verify?
```
This client method will verify the validity of response params send by Alipay using Alipay's
public key.

#### Example
```ruby
params = {
  out_trade_no: '20160401000000',
  trade_status: 'TRADE_SUCCESS'
  sign_type: 'RSA2',
  sign: '...'
}
@client.verify?(params)
# => true / false
```

##### Verify GET return_url
Alipay will send your customer via GET request to your specified `return_url`, if it was previously
defined during the payment creation process. Here is an example of how to verify response params
from Alipay in your controller.

```ruby
@client.verify?(request.query_parameters)
# => true / false
```

##### Verify POST notify_url
Alipay will send POST request to your specified `notify_url`, if it was previously defined during
the payment creation process. Your controller action should response 'success' in plain text or
Alipay will keep on sending POST requests in increasing intervals.

```ruby
if @client.verify?(request.request_parameters)
  render plain: 'success'
end
```

### Query Payment Status
#### API Method
```
alipay.trade.query
```
This API method is for querying payment status after the payment is created. It suitable for
situations when callbacks fail or when the created payment did not set callback parameters.

#### Client Method
```ruby
Alipay::Client.execute
```

#### Example
```ruby
response = @client.execute(
  method: 'alipay.trade.query',
  biz_content: {
    trade_no: '2013112611001004680073956707',
  }.to_json(ascii_only: true)
)
# => '{\"alipay_trade_query_response\":{\"code\"...'

# Get payment status
result_status = JSON.parse(response)["alipay_trade_query_response"]["trade_status"]
# => 'TRADE_SUCCESS'
```

Notable Parameters
* `trade_no` is the payment identification string provided by Alipay via callback after the payment is
created. If you do not have this on hand, you can provide the `out_trade_no` instead.

> For a complete list of the available parameters, please refer to the
[API documentation](https://docs.open.alipay.com/api_1/alipay.trade.query).

## Stop Payment
### Close Payment
#### API Method
```
alipay.trade.close
```
This API method is for closing inactive payment if you don't want to wait for Alipay to close
out the payment at its default expiration time.

#### Client Method
```ruby
Alipay::Client.execute
```

#### Example
```ruby
response = @client.execute(
  method: 'alipay.trade.close',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: {
    trade_no: '2013112611001004680073956707',
  }.to_json(ascii_only: true)
)
# => '{\"alipay_trade_close_response\":{\"code\"...'

# Get request result
result_code = JSON.parse(response)["alipay_trade_close_response"]["code"]
# => '10000'
```

#### Notable Parameters
* `trade_no` is the payment identification that Alipay returned to you after the payment was
pre-created. If you do not have this parameter on hand, you can stub in the 'out_trade_no' that you
used using the payment creation process.

> For a complete list of the available parameters, please refer to the
[API documentation](https://docs.open.alipay.com/api_1/alipay.trade.close).

### Cancel Payment
#### API Method
```
alipay.trade.cancel
```
This API method is for canceling stuck payment or payment that errors out due to either Alipay
or your own application. If the customer has successfully made the payment. A refund will be made.
If customers had not pay yet, the payment transaction will be close. You can check if a refund
had been made by getting the `action` value from the request response.

#### Client Method
```ruby
Alipay::Client.execute
```

#### Example
```ruby
response = @client.execute(
  method: 'alipay.trade.cancel',
  biz_content: {
    out_trade_no: '20160401000000',
  }.to_json(ascii_only: true)
)
# => '{\"alipay_trade_cancel_response\":{\"code\"...'

# Get cancellation result
result_action = JSON.parse(response)["alipay_trade_cancel_response"]["action"]
# => 'close'
```

#### Notable Parameters
* `out_trade_no` is a unique string that you provided during the payment creation process. You must
provide either `out_trade_no` or `trade_no` in order for the API call to be successful.

> For a complete list of the available parameters, please refer to the
[API documentation](https://docs.open.alipay.com/api_1/alipay.trade.cancel/).

## Refund Payment

### Initiate Refund
#### API Method
```
alipay.trade.refund
```
This API method is for initiating refunds to customers. Only made this API call if the payment has not passed the refund period defined by Alipay. Multiple or partial refunds are also available through this API.

#### Client Method
```ruby
Alipay::Client.execute
```

#### Example
Secenario: Customer request refund on a ￥10.12 item on a ￥210.85 order(payment).
```ruby
response = @client.execute(
  method: 'alipay.trade.refund',
  biz_content: {
    out_trade_no: '6c50789a0610',
    out_request_no: '6c50789a0610-1',
    refund_amount: '10.12'
  }.to_json(ascii_only: true)
)
# => '{\"alipay_trade_refund_response\":{\"code\"...'

# Get result
result_code = JSON.parse(response)["alipay_trade_refund_response"]["code"]
# => '10000'

result_fund_change = JSON.parse(response)["alipay_trade_refund_response"]["fund_change"]
# => 'Y'
```

#### Notable Parameters
* `out_request_no` is an *conditional optional* parameter. It is *required* when you make a partial
refund or plan to make multiple refunds. It serves as identification for the refund transaction.
It is *optional* when you refund the entire payment amount.
* `refund_amount` is the amount you wish to refund to the customer. It can be lower than the original
payment amount. However, if you have previously issued partial refunds on a payment, the sum
of `refund_amount` cannot exceed the original payment amount.

> For a complete list of the available parameters, please refer to the
[API documentation](https://docs.open.alipay.com/api_1/alipay.trade.refund/).

### Query Refund Status
#### API Method
```
alipay.trade.fastpay.refund.query
```
This API method is for querying refund status.

#### Client Method
```ruby
Alipay::Client.execute
```

#### Example
```ruby
response = @client.execute(
  method: 'alipay.trade.fastpay.refund.query',
  biz_content: {
    out_trade_no: '6c50789a0610',
    out_request_no: '6c50789a0610-1'
  }.to_json(ascii_only: true)
)
# => '{\"alipay_trade_fastpay_refund_query_response\":{\"code\"...'

# Get refund amount
result_refund_amount = JSON.parse(response)["alipay_trade_fastpay_refund_query_response"]["refund_amount"]
# => '10.12'
```

#### Notable Parameters
* `out_request_no` is the identifying string provided by you provided when you initiated the refund.
If you did not provide this parameter when the refund was initiated, use the `out_trade_no` as your
`out_request_no`.

> For a complete list of the available parameters, please refer to the
[API documentation](https://docs.open.alipay.com/api_1/alipay.trade.fastpay.refund.query/).


## Fund Transfer
### Transfer Fund to Customer
#### API Method
```
alipay.fund.trans.toaccount.transfer
```
This API method is for creating a fund transfer to customers from your Alipay account.

#### Client Method
```
Alipay::Client.execute
```

#### Example
```ruby
response = @client.execute(
  method: 'alipay.fund.trans.toaccount.transfer',
  biz_content: {
    out_biz_no: '3142321423432',
    payee_type: 'ALIPAY_LOGONID',
    payee_account: 'customer@example.com',
    amount: '12.23'
  }.to_json(ascii_only: true)
)
# => '{\"alipay_fund_trans_toaccount_transfer_response\":{\"code\"...'

# Get order ID
result_order_id = JSON.parse(response)["alipay_fund_trans_toaccount_transfer_response"]["order_id"]
# => '20160627110070001502260006780837'
```

#### Notable Parameters
* `out_biz_no` is a unique identifying string provided by you for reference purposes.
* `payee_type` is for defining the type of `payee_account` that is provided. Valid values
are `ALIPAY_USERID` for customer's Alipay user ID starting with `2088` and `ALIPAY_LOGONID` for
customer cellular number or email address.
* `payee_account` is the customer Alipay ID, email or cellular number. It must match the `payee_type`
provided.
* `amount` is the amount you wish to transfer to the customer. (e.g. ￥123.50 is `123.50`)

> For a complete list of the available parameters, please refer to the
[API documentation](https://docs.open.alipay.com/api_28/alipay.fund.trans.toaccount.transfer).

### Query Fund Transfer
#### API Method
```
alipay.fund.trans.order.query
```
This API method is for querying fund transfer status.

#### Client Method
```
Alipay::Client.execute
```

#### Example
```ruby
response = @client.execute(
  method: 'alipay.fund.trans.order.query',
  biz_content: {
    out_biz_no: '3142321423432',
  }.to_json(ascii_only: true)
)
# => '{\"alipay_fund_trans_order_query_response\":{\"code\"...'

# Get refund_status
refund_status = JSON.parse(response)["alipay_fund_trans_order_query_response"]["status"]
# => 'SUCCESS'

# Get expected refund date
refund_status = JSON.parse(response)["alipay_fund_trans_order_query_response"]["arrival_time_end"]
# => '2018-01-01 08:08:08'
```

#### Notable Parameters
* 'order_id' is the order id provided by Alipay when the transfer request was created. If you
do not have this on hand, you can stub in `out_biz_no` instead.

> For a complete list of the available parameters, please refer to the
[API documentation](https://docs.open.alipay.com/api_28/alipay.fund.trans.order.query/).
