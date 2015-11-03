# Alipay

A unofficial alipay ruby gem.

Alipay official document: https://b.alipay.com/order/techService.htm .

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alipay', '~> 0.9.0'
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

Alipay::Notify.verify?(notify_params)
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


### 账单明细分页查询接口

#### Name

```ruby
account.page.query
```

#### Definition

```ruby
Alipay::Service::account_page({PARAMS}, {OPTIONS})
```

#### Arguments

| params | name | type | description | required | example |
|--------|------|------|-------------|----------|---------|
| page_ no| 查询页号| String | 查询页号。必须是正整数。| 不可空 | 1 |
| gmt_start_time | 账务查询开始时间 | String | 账务查询开始时间。 格式为 yyyy-MM-dd HH:mm:ss。 开始时间不能大于当前时间和查询结束时间,并且与账 务查询结束时间的间隔不能 大于1天。 开始时间最早为当前时间前 3年。 当查询条件含有账务流水 号、支付宝交易号、商户订 单号、充值网银流水号中任意一个时,本参数可空,否则不可空。 查询结果数据包含该时间点数据。| 可空 | 2010-09-25 00:00:00 |
| gmt_end_time | 账务查询结 束时间 | String | 账务查询结束时间。 格式为 yyyy-MM-dd HH:mm:ss。 结束时间不能小于账务查询 开始时间,并且与账务查询 开始时间的间隔不能大于 1 天。 当查询条件含有账务流水 号、支付宝交易号、商户订 单号、充值网银流水号中任 意一个时,本参数可空,否 则不可空。 查询结果数据不包含该时间点数据。| 可空 | 2010-09-26 00:00:00 |
|logon_id | 交易收款账户 | String | 查询的收款账户,需要联系 支付宝绑定与商户 PID 的对 应关系。 若为空,表示查 PID 所属交 易。| 可空 | air001@alitest.com |
| iw_account_log_id | 账务流水号 | String(16) | 业务流水号字段对于交易数 据为交易号,对于转账、充 值、提现等资金操作,此处 为业务流水号。 当查询条件含有账务流水 号、业务流水号、商户订单 号、充值网银流水号中任意 一个时,账务查询开始时间 和账务查询结束时间无效。 查询优先级如下:账务流水 号>业务流水号>商户订单 号>充值网银流水号。当存在 优先级高的参数时,优先级 低的参数无效。| 可空 | 340005462320 |
| trade_no | 业务流水号 | String(64) | 可空 | 2012050726014177 |
| merchant_out_order_no | 商户订单号 | String(128) | 可空 | 201205131708360139 |
| deposit_bank_no | 充值网银流水号 | String(128) | 可空 | 2012145258965236 |
| page_size | 分页大小 | String | 每页记录数。 | 小于等于 5000 的正整数。为空或者大于 5000 时,默认 为 5000。| 可空 | 1 |
| trans_code | 交易类型代码 | String | 交易类型代码,参见“7.3 交 易类型代码”。 多个交易类型代码之间以半 角逗号“,”分隔。| 可空 | 6001 |

#### Example

```ruby
Alipay::Service.account_page(
  page_no: 1,
  gmt_start_time: "2015-10-25 00:00:00",
  gmt_end_time: "2015-10-26 00:00:00"
)
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
