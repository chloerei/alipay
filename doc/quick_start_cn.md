简易入门指南
=================

### [English](quick_start_en.md)

## 导航
* [设置客户端](#设置客户端)
    * [Ruby](#ruby)
    * [Ruby on Rails](#ruby-on-rails)
* [创建支付订单](#创建支付订单)
    * [电脑网站支付](#电脑网站支付)
    * [手机网站支付](#手机网站支付)
    * [扫码支付](#扫码支付)
    * [分期付款](#分期付款)
    * [验证回调数据](#验证回调数据)
    * [查询支付状态](#查询支付状态)
* [终止支付订单](#终止支付订单)
    * [关闭交易](#关闭交易)
    * [撤销交易](#撤销交易)
* [交易退款](#交易退款)
    * [发起退款](#发起退款)
    * [查询退款状态](#查询退款状态)
* [转帐](#转帐)
    * [转帐到顾客支付宝账户](#转帐到顾客支付宝账户)
    * [查询转帐状态](#查询转帐状态)



## 设置客户端

**指南内所有的示例会假设你已设置好客户端**

### Ruby
```ruby
# 保存好应用ID，密钥，API接口地址等设置
API_URL: 'https://openapi.alipaydev.com/gateway.do'
APP_ID: '2016000000000000'
APP_PRIVATE_KEY: "-----BEGIN RSA PRIVATE KEY-----\nxkbt...4Wt7tl\n-----END RSA PRIVATE KEY-----\n"
ALIPAY_PUBLIC_KEY: "-----BEGIN PUBLIC KEY-----\nTq43T5...OVUAQb3R\n-----END PUBLIC KEY-----\n"

# 建立一个客户端以便快速调用API
@client = Alipay::Client.new(
  url: API_URL,
  app_id: APP_ID,
  app_private_key: APP_PRIVATE_KEY,
  alipay_public_key: ALIPAY_PUBLIC_KEY
)
```

### Ruby on Rails
你可以保存你的支付宝设置为环境变量，或者建立一个文档在Rails初始化时导入。

在这个范例里，我们将使用 `dotenv-rails` gem 把支付宝所需设置保存为环境变量.

在你的 Gemfile
```ruby
# Gemfile
gem 'alipay', '~> 0.15.0'
gem 'dotenv-rails', '~> 2.2', '>= 2.2.1'
```
命令行运行
```bash
$ bundle install
```

Rails 根目录下创建一个 .env 文件
```ruby
# .env
APP_ID=2016000000000000
ALIPAY_API=https://openapi.alipaydev.com/gateway.do
APP_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\nxkbt...4Wt7tl\n-----END RSA PRIVATE KEY-----\n"
ALIPAY_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----\nTq43T5...OVUAQb3R\n-----END PUBLIC KEY-----\n"
```

设后置好，你可以在你的 Ruby on Rails 应用里使用环境变量创建一个支付宝 API 客户端
```ruby
@client = Alipay::Client.new(
  url: ENV['ALIPAY_API'],
  app_id: ENV['APP_ID'],
  app_private_key: ENV['APP_PRIVATE_KEY'],
  alipay_public_key: ENV['ALIPAY_PUBLIC_KEY']
)
```

## 创建支付订单

### 电脑网站支付
#### API 接口
```
alipay.trade.page.pay
```
这个 API 接口主要是用于在顾客在电脑网站下单并发起支付。

#### 客户端函数
```ruby
Alipay::Client.page_execute_url
```
这个客户端函数调用后会返回一条重定向顾客用的支付地址。

#### 示例
```ruby
@client.page_execute_url(
  method: 'alipay.trade.page.pay',
  return_url: 'https://mystore.com/orders/20160401000000/return',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: JSON.generate({
   out_trade_no: '20160401000000',
   product_code: 'FAST_INSTANT_TRADE_PAY',
   total_amount: '0.01',
   subject: 'Example #123'
  }, ascii_only: true)
)
# => 'https://openapi.alipaydev.com/gateway.do?app_id=2016...'
```

#### 值得注意的参数
* `return_url` 是提供给支付宝的同步返回地址。客户支付成功后，支付宝会使用 GET 请求将用户重定向到这个地址。这个一个*选填*参数，可不提供。
* `notify_url` 是提供给支付宝的异步返回地址。客户支付成功后，支付宝会以 POST 请求方式把交易信息发到这个地址上。这时一个*选填*参数。可不提供。
* `out_trade_no` 是你作为商户提供给支付宝的订单号。建议引用你应用内相应模型的 ID，并不能重复。
* `total_amount` 是支付订单的金额，精确到小数点后两位。例如金额 5,123.99 元的参数值应为 '5123.99'。

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/270/alipay.trade.page.pay/).


### 手机网站支付
#### API 接口
```
alipay.trade.wap.pay
```
这个 API 接口适用于顾客在手机网站环境下创建支付订单。如顾客手机内装有支付宝钱包，重定向到这个接口将会唤起手机上支付宝钱包。如顾客未安装支付宝应用，则将会重新向到移动版支付页面。

#### 客户端函数
```ruby
Alipay::Client.page_execute_url
```
这个客户端函数调用后会返回一条重定向顾客用的支付地址。

#### 示例
```ruby
@client.page_execute_url(
  method: 'alipay.trade.wap.pay',
  return_url: 'https://mystore.com/orders/20160401000000/return',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: JSON.generate({
   out_trade_no: '20160401000000',
   product_code: 'QUICK_WAP_WAY',
   total_amount: '0.01',
   subject: 'Example: 456'
   quit_url: 'https://mystore.com/orders/20160401000000/'
  }, ascii_only: true)
)
# => 'https://openapi.alipaydev.com/gateway.do?app_id=2016...'
```
#### 值得注意的参数
* `quit_url` 顾客在移动版支付页面时，支付宝会以这个参数所提供的地址生成一个返回按钮。

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/203/107090/).

### 扫码支付
#### API 接口
```
alipay.trade.precreate
```
这个 API 接口在提供支付订单数据后，将会创建订单并返回一个生成二维码用的支付地址。支付成功后支付宝会向 `notify_url` 设定的异步通知地址发送交易数据。

#### 客户端函数
```ruby
Alipay::Client.execute
```

#### 示例
```ruby
# 创建支付订单并取得订单信息
response = @client.execute(
  method: 'alipay.trade.precreate',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: JSON.generate({
    out_trade_no: '20160401000000',
    total_amount: '50.00',
    subject: 'QR Code Test'
  }, ascii_only: true)
)
# => '{\"alipay_trade_precreate_response\":{\"code\"...'

# 提取二维码地址
qr_code = JSON.parse(response)["alipay_trade_precreate_response"]["qr_code"]
# => 'https://qr.alipay.com/abcdefggfedcba'
```

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/api_1/alipay.trade.precreate).

### 分期付款
#### API 接口
```
alipay.trade.page.pay  (电脑网站)
alipay.trade.wap.pay  (手机网站)
alipay.trade.precreate  (扫码支付)
```

#### 客户端函数
```ruby
Alipay::Client.page_execute_url  (电脑网站 / 手机网站)
Alipay::Client.execute  (扫码支付)
```

#### 示例
情景：顾客在商城网站上预先选择好分6期付款的方案。商城和支付宝创建支付订单时同时提供分期参数。

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
   extend_params: JSON.generate({
     hb_fq_num: '6'',
     hb_fq_seller_percent: '0'
   }
  }, ascii_only: true)
)
```
情景：商城网站不提供分期选项，但允许客户在支付宝的支付过程中自行决定分期付款。
```ruby
@client.page_execute_url(
  method: 'alipay.trade.page.pay',
  return_url: 'https://mystore.com/orders/20160401000000/return',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: JSON.generate({
   out_trade_no: '20160401000000',
   product_code: 'FAST_INSTANT_TRADE_PAY',
   total_amount: '0.01',
   subject: 'Example #654',
   enable_pay_channels: 'balance,pcreditpayInstallment',
  }, ascii_only: true)
)
```
#### 值得注意的参数
* `enable_pay_channels` 这个参数指定用户可使用的付款渠道。 `pcreditpayInstallment` 是分期付款的参数值。可同时指定多个参数值。
* `hb_fq_num` 这个参数指定分期数. 有效的参数值为 `3`，`6`， 和 `12`。
* `hb_fq_seller_percent` 这个参数指定商户分担分期手续费的比例。有效参数值为`0`或`100`。

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/277/106748/).


### 验证回调数据
#### 客户端函数
```
Alipay::Client.verify?
```
这个客户端函数将会使用支付宝所提供的公钥来验证回调数据。

#### 示例
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

##### 验证 GET return_url 同步通知
支付宝会在顾客支付成功后，将客户以 GET 请求的方式重定向顾客到你指定的 `return_url` 地址。以下将简单地示范如何在你应用的 Controller 里验证回调数据。

```ruby
@client.verify?(request.query_parameters)
# => true / false
```

##### 验证 POST notify_url 异步通知
支付宝在顾客支付成功后，会向你所指定的 `notify_url` 以 POST 请求方式发送异步通知。你的应用对应的Controller需以纯文本方式返回 `success` 这7个字符。否则支付宝会继续尝试发送异步通知。

```ruby
if @client.verify?(request.request_parameters)
  render plain: 'success'
end
```

### 查询支付状态
#### API 接口
```
alipay.trade.query
```
这个 API 接口适用于在未接收到同步/异步通知的情况下查询订单支付状态。这个接口同时也适用于查询未设定同步/异步通知地址的订单。

#### 客户端函数
```ruby
Alipay::Client.execute
```

#### 示例
```ruby
response = @client.execute(
  method: 'alipay.trade.query',
  biz_content: JSON.generate({
    trade_no: '2013112611001004680073956707',
  }, ascii_only: true)
)
# => '{\"alipay_trade_query_response\":{\"code\"...'

# Get payment status
result_status = JSON.parse(response)["alipay_trade_query_response"]["trade_status"]
# => 'TRADE_SUCCESS'
```

#### 值得注意的参数
* `trade_no` 是创建支付订单后，支付宝返回的交易号。如未取得交易号，可以使用创建订单时所传入的商户订单号来代替。

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/api_1/alipay.trade.query).

## 终止支付订单
### 关闭交易
#### API 接口
```
alipay.trade.close
```
这个 API 接口适用于用户在一定时间内未支付，但未在支付宝系统内超时的情况下对未付款的建议进行关闭。

#### 客户端函数
```ruby
Alipay::Client.execute
```

#### 示例
```ruby
response = @client.execute(
  method: 'alipay.trade.close',
  notify_url: 'https://mystore.com/orders/20160401000000/notify',
  biz_content: JSON.generate({
    trade_no: '2013112611001004680073956707',
  }, ascii_only: true)
)
# => '{\"alipay_trade_close_response\":{\"code\"...'

# 取得请求结果代码
result_code = JSON.parse(response)["alipay_trade_close_response"]["code"]
# => '10000'
```

#### 值得注意的参数
* `trade_no` 是创建支付订单后，支付宝返回的交易号。如未取得交易号，可以使用创建订单时所传入的商户订单号来代替。

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/api_1/alipay.trade.close).

### 撤销交易
#### API 接口
```
alipay.trade.cancel
```
这个 API 接口适用于支付交易返回失败或支付系统超时的情况下撤销交易订单。如果顾客已成功付款，款项会以原渠道退回给顾客。并返回 `action` 值 `refund`。如客户尚未付款，订单会被关闭并返回 `action` 值 `close`。

#### 客户端函数
```ruby
Alipay::Client.execute
```

#### 示例
```ruby
response = @client.execute(
  method: 'alipay.trade.cancel',
  biz_content: JSON.generate({
    out_trade_no: '20160401000000',
  }, ascii_only: true)
)
# => '{\"alipay_trade_cancel_response\":{\"code\"...'

# 取得撤销结果
result_action = JSON.parse(response)["alipay_trade_cancel_response"]["action"]
# => 'close'
```

#### 值得注意的参数
* `trade_no` 是创建支付订单后，支付宝返回的交易号。如未取得交易号，可以使用创建订单时所传入的商户订单号来代替。

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/api_1/alipay.trade.cancel/).

## 交易退款

### 发起退款
#### API 接口
```
alipay.trade.refund
```
这个 API 接口适用于对已成功的交易订单发起退款。退款可拆分成多笔操作。如支付订单已超支付宝的退款期限，退款请求会失败。

#### 客户端函数
```ruby
Alipay::Client.execute
```

#### 示例
情景：顾客请求总额为 210.85 元的订单退款 10.12 元。
```ruby
response = @client.execute(
  method: 'alipay.trade.refund',
  biz_content: JSON.generate({
    out_trade_no: '6c50789a0610',
    out_request_no: '6c50789a0610-1',
    refund_amount: '10.12'
  }, ascii_only: true)
)
# => '{\"alipay_trade_refund_response\":{\"code\"...'

# 取得结果
result_code = JSON.parse(response)["alipay_trade_refund_response"]["code"]
# => '10000'

result_fund_change = JSON.parse(response)["alipay_trade_refund_response"]["fund_change"]
# => 'Y'
```

#### 值得注意的参数
* `out_request_no` 是 *条件可选* 参数. 如果你打算以同一张支付订单发起分多次退款，这则是*必选*参数。如你计划对支付订单进行一次性全额退款，这则是*可选*参数。
* `refund_amount` 是你退款单的金额。该金额可小于支付订单金额。但如之前以同一支付订单已产生退款，所有退款单的总额不能超出支付订单的总额。

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/api_1/alipay.trade.refund/).

### 查询退款状态
#### API 接口
```
alipay.trade.fastpay.refund.query
```
这个 API 接口适用于查询退款状态和一些退款的参数。

#### 客户端函数
```ruby
Alipay::Client.execute
```

#### 示例
```ruby
response = @client.execute(
  method: 'alipay.trade.fastpay.refund.query',
  biz_content: JSON.generate({
    out_trade_no: '6c50789a0610',
    out_request_no: '6c50789a0610-1'
  }, ascii_only: true)
)
# => '{\"alipay_trade_fastpay_refund_query_response\":{\"code\"...'

# 取得退款金额
result_refund_amount = JSON.parse(response)["alipay_trade_fastpay_refund_query_response"]["refund_amount"]
# => '10.12'
```

#### 值得注意的参数
* `out_request_no` 是你创建退款单时所提供给支付宝的单号。如支付订单仅有一笔退款，则可使用 `out_trade_no` 来代替。

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/api_1/alipay.trade.fastpay.refund.query/).


## 转帐
### 转帐到顾客支付宝账户
#### API 接口
```
alipay.fund.trans.toaccount.transfer
```
这个 API 接口适用于从你的商户支付宝账户转帐到顾客支付宝帐号。

#### 客户端函数
```
Alipay::Client.execute
```

#### 示例
```ruby
response = @client.execute(
  method: 'alipay.fund.trans.toaccount.transfer',
  biz_content: JSON.generate({
    out_biz_no: '3142321423432',
    payee_type: 'ALIPAY_LOGONID',
    payee_account: 'customer@example.com',
    amount: '12.23'
  }, ascii_only: true)
)
# => '{\"alipay_fund_trans_toaccount_transfer_response\":{\"code\"...'

# 取得转帐ID
result_order_id = JSON.parse(response)["alipay_fund_trans_toaccount_transfer_response"]["order_id"]
# => '20160627110070001502260006780837'
```

#### 值得注意的参数
* `out_biz_no` 是你提供给支付宝的唯一转帐ID
* `payee_type` 是用于识别 `payee_account` 提供的账户类型。 有效值为 `ALIPAY_USERID` ，适用于提供开头为 `2088` 的支付宝用户号。另一有效值 `ALIPAY_LOGONID` 适用于以用户邮箱，手机，和登录号来识别。
* `payee_account` 是用户的支付宝ID，邮箱地址，登录号，和手机号码。这个参数必须匹配所提供 `payee_type` 值。
* `amount` 是转帐金额，精确到小数点后两位数。 (例如： ￥123.50 值为 `123.50`)

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/api_28/alipay.fund.trans.toaccount.transfer).

### 查询转帐状态
#### API 接口
```
alipay.fund.trans.order.query
```
这个 API 接口适用于查询转帐状态

#### 客户端函数
```
Alipay::Client.execute
```

#### 示例
```ruby
response = @client.execute(
  method: 'alipay.fund.trans.order.query',
  biz_content: JSON.generate({
    out_biz_no: '3142321423432',
  }, ascii_only: true)
)
# => '{\"alipay_fund_trans_order_query_response\":{\"code\"...'

# 取得转帐状态
refund_status = JSON.parse(response)["alipay_fund_trans_order_query_response"]["status"]
# => 'SUCCESS'

# 取得预计到帐时间
refund_status = JSON.parse(response)["alipay_fund_trans_order_query_response"]["arrival_time_end"]
# => '2018-01-01 08:08:08'
```

#### 值得注意的参数
* 'order_id' 是创建转帐交易时所返回的ID。如没有取得该ID，则可使用 `out_biz_no` 来代替。

> 如需 API 接口的完整参数列表，请参考官方的 [API 文档](https://docs.open.alipay.com/api_28/alipay.fund.trans.order.query/).
