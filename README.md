# Alipay

Unofficial alipay ruby gem.

*This branch is not stable, use it at your own risk*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alipay', github: 'chloerei/alipay', branch: 'openapi'
```

Then run:

```console
$ bundle
```

## Usage

```ruby
alipay_client = Alipay::Client.new(
  url: 'https://openapi.alipaydev.com/gateway.do',
  app_id: '2016000000000000',
  app_private_key: APP_PRIVATE_KEY,
  alipay_public_key: ALIPAY_PUBLIC_KEY
)

alipay_client.page_execute_url(
  method: 'alipay.trade.page.pay',
  biz_content: {
    out_trade_no: '20160401000000',
    product_code: 'FAST_INSTANT_TRADE_PAY',
    total_amount: '0.01',
    subject: 'test'
  }.to_json, # to_json is important!
  timestamp: '2016-04-01 00:00:00'
)
# => 'https://openapi.alipaydev.com/gateway.do?app_id=201600...'
```

Read [Alipay::Client](lib/alipay/client.rb) for more detail.

You can find legacy API document [here](doc/legacy_api.md).

## Contributing

Bug report or pull request are welcome.

### Make a pull request

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write unit test with your code if necessary.

## License

MIT License
