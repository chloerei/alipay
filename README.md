# Alipay

A simple alipay ruby gem, without unnecessary magic or wraper, it's directly facing how alipay api works.

It contain this API:

* Generate payment url
* Send goods
* Verify notify

Please read alipay official document first: https://b.alipay.com/order/techService.htm .

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alipay', '~> 0.0.3'
```

or development version

```ruby
gem 'alipay', :github => 'chloerei/alipay'
```

And then execute:

```sh
$ bundle
```

## Usage

### Config

```ruby
Alipay.pid = 'YOUR_PID'
Alipay.key = 'YOUR_KEY'
Alipay.seller_email = 'YOUR_SELLER_EMAIL'
```

### Generate payment url

```ruby
options = {
  :out_trade_no      => 'YOUR_ORDER_ID',         # 20130801000001
  :subject           => 'YOUR_ORDER_SUBJECCT',   # Writings.io Base Account x 12
  :logistics_type    => 'DIRECT',
  :logistics_fee     => '0',
  :logistics_payment => 'SELLER_PAY',
  :price             => '10.00',
  :quantity          => 12,
  :discount          => '20.00',
  :return_url        => 'YOUR_ORDER_RETURN_URL', # https://writings.io/orders/20130801000001
  :notify_url        => 'YOUR_ORDER_NOTIFY_URL'  # https://writings.io/orders/20130801000001/alipay_notify
}

Alipay::Service.create_partner_trade_by_buyer_url(options)
# => 'https://mapi.alipay.com/gateway.do?out_trade_no=...'
```

You can redirect user to this payment url, and user will see a payment page for his/her order.

Current support three payment type:

    Alipay::Service#create_partner_trade_by_buyer_url # 担保交易
    Alipay::Service#trade_create_by_buyer_url         # 标准双接口
    Alipay::Service#create_direct_pay_by_user_url     # 即时到帐

### Generate payment url for wap

```ruby
options = {
  :req_data => {
    :out_trade_no  => 'YOUR_ORDER_ID',         # 20130801000001
    :subject       => 'YOUR_ORDER_SUBJECCT',   # Writings.io Base Account x 12
    :total_fee     => 'TOTAL_FEE',
    :notify_url    => 'YOUR_ORDER_NOTIFY_URL', # https://writings.io/orders/20130801000001/alipay_notify
    :call_back_url => 'YOUR_ORDER_RETURN_URL'  # https://writings.io/orders/20130801000001
  }
}

token = Alipay::Service::Wap.trade_create_direct_token(options)
Alipay::Service::Wap.auth_and_execute(request_token: token)
# => 'http://wappaygw.alipay.com/service/rest.htm?req_data=...'
```

You can redirect user to this payment url, and user will see a payment page for his/her order.

Current only support this payment type:

    Alipay::Service::Wap.auth_and_execute # 即时到帐

### Send goods

```ruby
options = {
  :trade_no       => 'TRADE_NO',
  :logistics_name => 'writings.io',
  :transport_type => 'DIRECT'
}

Alipay::Service.send_goods_confirm_by_platform(options)
# => '<!xml version="1.0" encoding="utf-8"?><alipay><is_success>T</is_success></alipay>'
```

### Refund

```ruby
batch_no = Alipay::Utils.generate_batch_no # refund batch no, you SHOULD store it to db to avoid alipay duplicate refund
options = {
    batch_no:   batch_no,
    data:       [{:trade_no => 'TRADE_NO', :amount => '10.0', :reason => 'REFUND_REASON'}],
    notify_url: 'YOUR_ORDER_NOTIFY_URL'  # https://writings.io/orders/20130801000001/alipay_refund_notify
}

Alipay::Service.create_refund_url(options)
```

Batch No. Generate Demo: http://git.io/GcXKJw
Notify Url Demo: http://git.io/pst4Tw

### Verify notify

```ruby
# example in rails
# The notify url MUST be set when generate payment url
def alipay_notify
  # except :controller_name, :action_name, :host, etc.
  notify_params = params.except(*request.path_parameters.keys)
  if Alipay::Notify.verify?(notify_params)
    # valid notify, code your business logic.
    render :text => 'success'
  else
    render :text => 'error'
  end
end
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

Alipay donate link: https://me.alipay.com/chloerei .
