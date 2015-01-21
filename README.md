# Alipay

A simple alipay ruby gem, without unnecessary magic or wraper, it's directly facing how alipay api works.

It contain this API:

* Generate payment url (web, wap)
* Send goods
* Close trade
* Verify notify (web, wap, app)

Please read alipay official document first: https://b.alipay.com/order/techService.htm .

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alipay', '~> 0.1.0'
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

### Generate payment url for web

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

### Close trade

```ruby
Alipay::Service.close_trade(
  :trade_no     => 'TRADE_NO',
  :out_order_no => 'the-out-order-no'
)
# => '<?xml version="1.0" encoding="utf-8"?><alipay><is_success>T</is_success></alipay>'
```

You must specify either `trade_no` or `out_order_no`.

If Alipay fail to close trade, this method will return XML similar to:

```xml
<?xml version="1.0" encoding="utf-8"?>
<alipay>
  <is_success>F</is_success>
  <error>TRADE_STATUS_NOT_AVAILD</error>
</alipay>
```

## Single trade query

The parameters same as [Close trade](#user-content-close-trade)

```ruby
Alipay::Service.single_trade_query(
  :trade_no     => 'TRADE_NO',
  :out_order_no => 'the-out-order-no'
)
# => '<?xml version="1.0" encoding="utf-8"?><alipay><is_success>T</is_success><request><param name="trade_no">111111111</param><param name="_input_charset">utf-8</param><param name="service">single_trade_query</param><param name="partner">2222222222</param></request><response><trade><additional_trade_status>DAEMON_CONFIRM_CLOSE</additional_trade_status><buyer_email>foo@gmail.com</buyer_email><buyer_id>3333333</buyer_id><discount>0.00</discount><flag_trade_locked>0</flag_trade_locked><gmt_close>2015-01-20 02:37:00</gmt_close><gmt_create>2015-01-20 02:17:00</gmt_create><gmt_last_modified_time>2015-01-20 02:37:00</gmt_last_modified_time><is_total_fee_adjust>F</is_total_fee_adjust><operator_role>B</operator_role><out_trade_no>3279c7a082350132046800163d002e71</out_trade_no><payment_type>1</payment_type><price>640.00</price><quantity>1</quantity><seller_email>bar@gmail.com</seller_email><seller_id>100000001010101</seller_id><subject>[LC希澈家族&amp;amp;百度金希澈吧] SJ六巡澳门 团票【含内场和看台】</subject><to_buyer_fee>0.00</to_buyer_fee><to_seller_fee>0.00</to_seller_fee><total_fee>640.00</total_fee><trade_no>2015012013183181</trade_no><trade_status>TRADE_CLOSED</trade_status><use_coupon>F</use_coupon></trade></response><sign>aaaaaaaaaaaaaaaaaaaaaaa</sign><sign_type>MD5</sign_type></alipay>'
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
# Example in rails,
# notify url MUST be set when generate payment url

def alipay_web_notify
  # except :controller_name, :action_name, :host, etc.
  notify_params = params.except(*request.path_parameters.keys)

  if Alipay::Notify.verify?(notify_params)
    # Valid notify, code your business logic.
    # trade_status is base on your payment type
    # Example:
    #
    # case params[:trade_status]
    # when 'WAIT_BUYER_PAY'
    # when 'WAIT_SELLER_SEND_GOODS'
    # when 'TRADE_FINISHED'
    # when 'TRADE_CLOSED'
    # end
    render :text => 'success'
  else
    render :text => 'error'
  end
end

def alipay_wap_notify
  # except :controller_name, :action_name, :host, etc.
  notify_params = params.except(*request.path_parameters.keys)

  if Alipay::Notify::Wap.verify?(notify_params)
    # valid notify, code your business logic.
    # you may want to get you order id:
    #   order_id = Hash.from_xml(params[:notify_data])['notify']['out_trade_no']
    render :text => 'success'
  else
    render :text => 'error'
  end
end

def alipay_app_notify
  # except :controller_name, :action_name, :host, etc.
  notify_params = params.except(*request.path_parameters.keys)

  if Alipay::Notify::App.verify?(notify_params)
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

Alipay donate link: http://chloerei.com/donate/ .
