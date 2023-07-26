# Alipay

Unofficial Alipay ruby gem.

Note: Alipay::Client API does not have enough feedback in production yet, please fully test in your staging environment before production. You can find legacy API document [here](doc/legacy_api.md).

You should read [https://doc.open.alipay.com](https://doc.open.alipay.com) before using this gem.

## Installation

To install using [Bundler](http://bundler.io/). Add this line to your
application's Gemfile:

```ruby
gem 'alipay'
```

Then run:
```bash
$ bundle
```

Or you can manually install using [RubyGems](http://rubygems.org/):
```bash
$ gem install alipay
```

## Getting Started

This gem needs to be configured with your application's private key for Alipay and Alipay's public key. Here is a [quick guide](doc/rsa_key_en.md) on generating RSA key for use with this gem to get you started.

### Setup
```ruby
require 'alipay'

# setup the client to communicate with either production API or sandbox API
# https://openapi.alipay.com/gateway.do (Production)
# https://openapi.alipaydev.com/gateway.do (Sandbox)
API_URL =  'https://openapi.alipaydev.com/gateway.do'

# setup your own credentials and certificates
APP_ID = '2016xxxxxxxxxxxx'
APP_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\nxkbt...4Wt7tl\n-----END RSA PRIVATE KEY-----\n"
ALIPAY_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----\nTq43T5...OVUAQb3R\n-----END PUBLIC KEY-----\n"

# initialize a client to communicate with the Alipay API
@alipay_client = Alipay::Client.new(
  url: API_URL,
  app_id: APP_ID,
  app_private_key: APP_PRIVATE_KEY,
  alipay_public_key: ALIPAY_PUBLIC_KEY
)
```

### Create a payment
```ruby
@alipay_client.page_execute_url(
  method: 'alipay.trade.page.pay',
  biz_content: JSON.generate({
    out_trade_no: '20160401000000',
    product_code: 'FAST_INSTANT_TRADE_PAY',
    total_amount: '0.01',
    subject: 'test'
  }, ascii_only: true), # ascii_only is important!
  timestamp: '2016-04-01 00:00:00'
)

# This method will then return a payment url
# => 'https://openapi.alipaydev.com/gateway.do?app_id=201600...'
```

Read [Alipay::Client](lib/alipay/client.rb) or the [Quick Start Guide](doc/quick_start_en.md) for usage detail.

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
