## v0.6.0.beta2 (2015-04-01)

- Move `Alipay::Service::Wap` to `Alipay::Wap::Service`
- Move `Alipay::Sign::Wap` to `Alipay::Wap::Sign`
- Move `Alipay::Notify::Wap` to `Alipay::Wap::Notify`
- Rename `Alipay::Service.create_forex_single_refund_url` to `Alipay::Service.forex_refund_url`
- Rename `Alipay::Service.create_forex_trade` to `Alipay::Service.create_forex_trade_url`
- Rename `Alipay::Service.create_refund_url` to `Alipay::Service.refund_fastpay_by_platform_pwd_url`
- All service methods accept `options` args to config pid, seller_email and key.

## v0.6.0.beta1 (2015-03-26)

Usage:

- Add `Alipay.sign_type`, default is 'MD5', 'RSA' and 'DSA' will implemented in the future.
- Remove `Sign::App.verify?`, use `Sign.verify_rsa?` instead.
- Remove `Notify::App.verify?`, use `Notify.verify?` instead.
- Rename `Service::Wap.auth_and_execute` to `Service::Wap.auth_and_execute_url`

Development:

- Update Test::Unit to Minitest.
- Fxied test case data.

## v0.5.0 (2015-03-09)

- Add `forex_single_refund` service.
- Add `debug_mode` config:

  set `Alipay.debug_mode = false` to disable options check warning in production env.

## v0.4.1 (2015-03-03)

- Fix `single_trade_query` check options typo.

## v0.4.0 (2015-01-23)

- Add `single_trade_query` service. #19

## v0.3.1 (2015-01-15)

- Fix xml encoding #18

## v0.3.0 (2014-12-10)

- Add `close_trade` service. by @linjunpop #16

## v0.2.0 (2014-12-03)

- Add `create_forex_trade` service. by @christophe-dufour #15

## v0.1.0 (2014-06-15)

- Add Wap API by @HungYuHei

- Add App API by @HungYuHei
