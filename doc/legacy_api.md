# Alipay Legacy API

*It's recommended to use new alipay api - Open API, read [Alipay::Client](../lib/alipay/client.rb) for more detail.*

A unofficial alipay ruby gem.

Alipay official document: https://b.alipay.com/order/techService.htm .

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alipay', '~> 0.14.0'
```

And then execute:

```console
$ bundle
```

## Configuration

```ruby
Alipay.pid = 'YOUR_PID'
Alipay.key = 'YOUR_KEY'

#Alipay.sign_type = 'MD5' # Available values: MD5, RSA. Default is MD5
#Alipay.debug_mode = true # Enable parameter check. Default is true.
```

You can set default key, or pass a key directly to service method:

```ruby
Service.create_partner_trade_by_buyer_url({
  out_trade_no: 'OUT_TRADE_NO',
  # Order params...
}, {
  pid: 'ANOTHER_PID',
  key: 'ANOTHER_KEY',
})
```

## Service

### 担保交易收款接口

#### Name

```ruby
create_partner_trade_by_buyer
```

#### Definition

```ruby
Alipay::Service.create_partner_trade_by_buyer_url({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.create_partner_trade_by_buyer_url(
  out_trade_no: '20150401000-0001',
  subject: 'Order Name',
  price: '10.00',
  quantity: 12,
  logistics_type: 'DIRECT',
  logistics_fee: '0',
  logistics_payment: 'SELLER_PAY',
  return_url: 'https://example.com/orders/20150401000-0001',
  notify_url: 'https://example.com/orders/20150401000-0001/notify'
)
# => 'https://mapi.alipay.com/gateway.do?service=create_partner_trade_by_buyer&...'
```

Guide consumer to this address to complete payment

#### Arguments

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_order_no | required | Order id in your application. |
| subject | required | Order subject. |
| price | required | Order item's price. |
| quantity | required | Order item's quantity, total price is price * quantity. |
| logistics_type | required | Logistics type. Available values: POST, EXPRESS, EMS, DIRECT. |
| logistics_fee | required | Logistics fee. |
| logistics_payment | required | Who pay the logistics fee. Available values: BUYER_PAY, SELLER_PAY, BUYER_PAY_AFTER_RECEIVE. |
| return_url | optional | Redirect customer to this url after payment. |
| notify_url | optional | Alipay asyn notify url. |

This is not a complete list of arguments, please read official document: http://download.alipay.com/public/api/base/alipayescow.zip .

### 确认发货接口

#### Name

```ruby
send_goods_confirm_by_platform
```

#### Definition

```ruby
Alipay::Service.send_goods_confirm_by_platform({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.send_goods_confirm_by_platform(
  trade_no: '201504010000001',
  logistics_name: 'example.com',
  transport_type: 'DIRECT'
)
# => '<!xml version="1.0" encoding="utf-8"?><alipay><is_success>T</is_success></alipay>'
```

#### Arguments

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| trade_no | required | Trade number in Alipay system, should get from notify message. |
| logistics_name | required | Logistics Name. |
| transport_type/create_transport_type | required | Allowed values: POST, EXPRESS, EMS, DIRECT. |

This is not a complete list of arguments, please read official document: http://download.alipay.com/public/api/base/alipayescow.zip .

### 即时到账收款接口

#### Name

```ruby
create_direct_pay_by_user
```

#### Definition

```ruby
Alipay::Service.create_direct_pay_by_user_url({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.create_direct_pay_by_user_url(
  out_trade_no: '20150401000-0001',
  subject: 'Order Name',
  total_fee: '10.00',
  return_url: 'https://example.com/orders/20150401000-0001',
  notify_url: 'https://example.com/orders/20150401000-0001/notify'
)
```

#### Arguments

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_order_no | required | Order id in your application. |
| subject | required | Order subject. |
| total_fee | required | Order's total fee. |
| return_url | optional | Redirect customer to this url after payment. |
| notify_url | optional | Alipay asyn notify url. |

This is not a complete list of arguments, please read official document: http://download.alipay.com/public/api/base/alipaydirect.zip .

### 手机网站支付接口

#### Name

```ruby
alipay.wap.create.direct.pay.by.user
```

#### Definition

```ruby
Alipay::Service.create_direct_pay_by_user_wap_url({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.create_direct_pay_by_user_wap_url(
  out_trade_no: '20150401000-0001',
  subject: 'Order Name',
  total_fee: '10.00',
  return_url: 'https://example.com/orders/20150401000-0001',
  notify_url: 'https://example.com/orders/20150401000-0001/notify'
)
```

#### Arguments

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_order_no | required | Order id in your application. |
| subject | required | Order subject. |
| total_fee | required | Order's total fee. |
| return_url | optional | Redirect customer to this url after payment. |
| notify_url | optional | Alipay asyn notify url. |

This is not a complete list of arguments, please read official document: http://download.alipay.com/public/api/base/alipaywapdirect.zip .




### 国际支付宝移动接口

#### Name

```ruby
create_forex_trade_wap
```

#### Definition

```ruby
Alipay::Service.create_forex_trade_wap_url({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.create_forex_trade_wap_url(
  out_trade_no: '20150401000-0001',
  subject: 'Order Name',
  merchant_url: 'http://example.com/itemback',
  total_fee: '10.00', #or rmb_fee, only one
  currency: 'USD',
  return_url: 'https://example.com/orders/20150401000-0001',
  notify_url: 'https://example.com/orders/20150401000-0001/notify'
)
```

#### Arguments

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_order_no | required | Order id in your application. |
| subject | required | Order subject. |
| merchant_url | required | The link which customer could jump back to merchant page from Alipay cashier. |
| total_fee or rmb_fee | required | Order's total fee. |
| currency | required | currency type. |
| return_url | optional | Redirect customer to this url after payment. |
| notify_url | optional | Alipay asyn notify url. |

This is not a complete list of arguments, please read official document: https://global.alipay.com/product/mobilepayments.html .


### 即时到账批量退款有密接口

#### Name

```ruby
refund_fastpay_by_platform_pwd
```

#### Definition

```ruby
Alipay::Service.refund_fastpay_by_platform_pwd_url
```

#### Example

```ruby
batch_no = Alipay::Utils.generate_batch_no # refund batch no, you SHOULD store it to db to avoid alipay duplicate refund
Alipay::Service.refund_fastpay_by_platform_pwd_url(
  batch_no: batch_no,
  data: [{
    trade_no: '201504010000001',
    amount: '10.0',
    reason: 'REFUND_REASON'
  }],
  notify_url: 'https://example.com/orders/20150401000-0001/refund_notify'
)
# => https://mapi.alipay.com/gateway.do?service=refund_fastpay_by_platform_pwd&...
```

#### Arguments

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| batch_no | required | Refund batch no, you should store it to db to avoid alipay duplicate refund. |
| data | required | Refund data, a hash array. |
| notify_url | required | Alipay notify url. |

##### Data Item

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| trade_no | required | Trade number in alipay system. |
| amount | required | Refund amount. |
| reason | required | Refund reason. Less than 256 bytes, could not contain special characters: ^ $ &#124; #. |

This is not a complete list of arguments, please read official document: http://download.alipay.com/public/api/base/alipaydirect.zip .

### 关闭交易接口

#### Name

```ruby
close_trade
```

#### Definition

```ruby
Alipay::Service.close_trade({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.close_trade(
  trade_no: '201504010000001'
)
# => '<?xml version="1.0" encoding="utf-8"?><alipay><is_success>T</is_success></alipay>'

# When fail
# => '<?xml version="1.0" encoding="utf-8"?><alipay><is_success>F</is_success> <error>TRADE_STATUS_NOT_AVAILD</error></alipay>'
```

#### ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_order_no | optional * | Order number in your application. |
| trade_no | optional * | Trade number in alipay system. |

\* out_order_no and trade_no must have one.

### 单笔交易查询接口

#### Name

```ruby
single_trade_query
```

#### Definition

```ruby
Alipay::Service.single_trade_query({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.single_trade_query(
  trade_no: '201504010000001'
)
# => '<?xml version="1.0" encoding="utf-8"?><alipay><is_success>T</is_success>...
```

#### ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_trade_no | optional * | Order number in your application. |
| trade_no | optional * | Trade number in alipay system. |

\* out_trade_no and trade_no must have one.

### 境外收单接口

#### Name

```ruby
create_forex_trade
```

#### Definition

```ruby
Alipay::Service.create_forex_trade_url({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.create_forex_trade_url(
  out_trade_no: '20150401000-0001',
  subject: 'Subject',
  currency: 'USD',
  total_fee: '10.00',
  notify_url: 'https://example.com/orders/20150401000-0001/notify'
)
# => 'https://mapi.alipay.com/gateway.do?service=create_forex_trade...'
```

#### ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_trade_no | required | Order number in your application. |
| subject | required | Order subject. |
| currency | required | Abbreviated currency name. |
| total_fee | required * | Order total price. |
| notify_url | optional | Alipay asyn notify url. |

\* total_fee can be replace by rmb_fee.

### 境外收单单笔退款接口

#### Name

```ruby
forex_refund
```

#### Definition

```ruby
Alipay::Service.forex_refund_url({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.forex_refund_url(
  out_return_no: '20150401000-0001',
  out_trade_no: '201504010000001',
  return_amount: '10.00',
  currency: 'USD',
  reason: 'Reason',
  gmt_return: '20150401000000'
)
```

#### ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_return_no | required | Refund no, you should store it to db to avoid alipay duplicate refund. |
| out_trade_no | required | Order number in your application. |
| return_amount | required | Refund amount. |
| currency | required | Abbreviated currency name. |
| reason | required | Refun reason. |
| gmt_return | required * | YYYYMMDDHHMMSS Beijing Time. |

\* Auto set Time.now if not set.

### 账单明细分页查询接口

#### Name

```ruby
account.page.query
```

#### Definition

```ruby
Alipay::Service::account_page_query({PARAMS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.account_page_query(
  page_no: 1,
  gmt_start_time: '2015-10-25 00:00:00',
  gmt_end_time: '2015-10-26 00:00:00'
)
```

#### Arguments

It's an unpublic api, contact support for permission and document.

### 批量付款到支付宝账户接口

#### Name

```ruby
batch_trans_notify
```

#### Definition

```ruby
Alipay::Service::batch_trans_notify_url({PARAMS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Service.batch_trans_notify_url(
  notify_url: 'https://example.com/orders/20150401000-0001/notify',
  account_name: '毛毛',
  detail_data: '0315006^testture0002@126.com^常炜买家^1000.00^hello',
  batch_no: '20080107001',
  batch_num: 1,
  batch_fee: 1000.00,
  email: 'biz_932@alitest.com'
)
#=> 'https://mapi.alipay.com/gateway.do?service=batch_trans_notify&...'
```

#### Arguments

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| notify_url | required | Alipay asyn notify url. |
| account_name | required | Alipay account name of payer. |
| detail_data | required | Payment data. |
| batch_no | required | Batch transaction number. |
| batch_num | required | Batch transaction count. |
| batch_fee | required | Batch transaction total amount. |
| email | required | Alipay email account of payer. |

Document: https://doc.open.alipay.com/doc2/detail?treeId=64&articleId=103773&docType=1

### 验证通知

#### Name

```ruby
notify_verify
```

#### Definition

```ruby
Alipay::Notify.verify?({PARAMS}, {OPTIONS})
```

#### Example

```ruby
# Rails
# params except :controller_name, :action_name, :host, etc.
notify_params = params.except(*request.path_parameters.keys)

Alipay::Notify.verify?(notify_params, options = {})
```

## Mobile::Service

### 移动支付接口

#### Name

```ruby
mobile.securitypay.pay
```

#### Definition

```ruby
Alipay::Mobile::Service.mobile_securitypay_pay_string({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Mobile::Service.mobile_securitypay_pay_string(
  out_trade_no: '20150401000-0001',
  notify_url: 'https://example.com/orders/20150401000-0001/notify'
  subject: 'subject',
  total_fee: '10.00',
  body: 'text'
)
# => service="mobile.securitypay.pay"&_input_charset="utf-8"&partner=...
```

#### ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| out_trade_no | required | Order number in your application. |
| notify_url | required | Alipay asyn notify url. |
| subject | required | Order subject. |
| total_fee | required | Order total price. |
| body | required | Order body, less than 512 bytes. |

\* This service only support RSA sign_type.

This is not a complete list of arguments, please read official document: http://download.alipay.com/public/api/base/WS_MOBILE_PAY_SDK_BASE.zip .

## Wap::Service

### 授权接口

#### Name

```ruby
alipay.wap.trade.create.direct
```

#### Definition

```ruby
Alipay::Wap::Service.trade_create_direct_token({ARGUMENTS}, {OPTIONS}}
```

#### Example

```ruby
token = Alipay::Wap::Service.trade_create_direct_token(
  req_data: {
    seller_account_name: 'account@example.com',
    out_trade_no: '20150401000-0001',
    subject: 'Subject',
    total_fee: '10.0',
    call_back_url: 'https://example.com/orders/20150401000-0001',
    notify_url: 'https://example.com/orders/20150401000-0001/notify'
  }
)
```

#### ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| req_data | required | See req_data ARGUMENTS |

##### req_data ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| seller_account_name | required | Alipay seller account. |
| out_order_no | required | Order id in your application. |
| subject | required | Order subject. |
| total_fee | required | Order total price. |
| return_url | optional | Redirect customer to this url after payment. |
| notify_url | optional | Alipay asyn notify url. |

This is not a complete list of arguments, please read official document: http://download.alipay.com/public/api/base/WS_WAP_PAYWAP.zip .

### 交易接口

#### Name

```ruby
alipay.wap.auth.authAndExecute
```

#### Definition

```ruby
Alipay::Wap::Service.auth_and_execute_url({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Wap::Service.auth_and_execute_url(request_token: token)
```
#### ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| request_token | required | Get from trade_create_direct_token |

### 风险探测服务接口

#### Name

```ruby
alipay.security.risk.detect
```

#### Definition

```ruby
Alipay::Wap::Service.security_risk_detect({ARGUMENTS}, {OPTIONS})
```

#### Example

```ruby
Alipay::Wap::Service.security_risk_detect({
  order_no: '1',
  order_credate_time: '1970-01-01 00:00:00',
  order_category: 'TestCase^AlipayGem^Ruby',
  order_item_name: 'item',
  order_amount: '0.01',
  buyer_account_no: '2088123123',
  buyer_bind_mobile: '13600000000',
  buyer_reg_date: '1970-01-01 00:00:00',
  terminal_type: 'WAP'
}, {
  sign_type: 'RSA',
  key: RSA_PRIVATE_KEY
})
```
#### ARGUMENTS

| Key | Requirement | Description |
| --- | ----------- | ----------- |
| order_no | optional | Order id in your application. |
| order_credate_time | optional | Order created time. |
| order_category | optional | Categories of Order's items. using `^` as splitter. |
| order_item_name | optional | Order subject. |
| order_amount | optional | Order item's price. |
| buyer_account_no | optional | User id in your application. |
| buyer_reg_date | optional | User created time. |
| buyer_bind_mobile | optional | User mobile phone. |
| terminal_type | optional | The terminal type which user are using to request the payment, can be `MOBILE` for App, `WAP` for mobile, `WEB` for PC. |

### 验证通知

#### Name

```ruby
notify_verify
```

#### Definition

```ruby
Alipay::Wap::Notify.verify?({PARAMS}, {OPTIONS})
```

#### Example

```ruby
# Rails
# params except :controller_name, :action_name, :host, etc.
notify_params = params.except(*request.path_parameters.keys)

Alipay::Wap::Notify.verify?(notify_params)
```

## Contributing

Bug report or pull request are welcome.

### Make a pull request

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write unit test with your code if necessary.

## Donate

Donate to maintainer let him make this gem better.

Alipay donate link: http://chloerei.com/donate/ .
