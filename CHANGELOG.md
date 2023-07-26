## master

Newer release changelog, see https://github.com/chloerei/alipay/releases

## v0.16.0 (2020-05-15)

- Support certificate signature, thanks @moohao #92

## v0.15.2 (2019-08-02)

- page_execute_form invalid-signature charset, thanks @lingceng #90

## v0.15.1 (2018-06-16)

- Add `partner` and `seller_id` options for legacy API, thanks @KQyongzhang #83

## v0.15.0 (2017-08-27)

- Add `Alipay::Client` for open API.
- Stop adding new feature to Alipay::Service, Alipay::App::Service, Alipay::Wap::Service, Alipay::Mobile::Service.

## v0.14.0 (2016-12-28)

- Add `Alipay::App::Service.create_forex_trade_wap_url` method, thanks @xiaohesong #61

## v0.13.0 (2016-12-24)

- Add `Alipay::App::Service.alipay_trade_app_pay` method, thanks @FX-HAO #64

## v0.12.0 (2016-03-07)

- Add `Alipay::Service::batch_trans_notify_url` method, thanks @ryancheung #58

## v0.11.0 (2015-12-04)

- Add `Alipay::Wap::Service.security_risk_detect` method, thanks @jasl #55

## v0.10.0 (2015-11-03)

- Add `Alipay::Service.account_page_query` method, thanks @xjz19901211 #53

## v0.9.0 (2015-10-15)

- Add `Alipay::Service.create_direct_pay_by_user_wap_url` method, thanks @serco-chen #52

## v0.8.0 (2015-07-20)

- Add `Alipay::Mobile::Service.mobile_security_pay_string` method, thanks @Sen #49
- Remove `Alipay::Service.mobile_security_pay_url` #49

## v0.7.1 (2015-04-10)

- Don't warning when `rmb_fee` is used in forex_refund_url method.

## v0.7.0 (2015-04-07)

- Remove Alipay.seller_email setting, it can be replaced by seller_id, than same with pid.
- Alipay::Wap::Service.trade_create_direct_token add a required params: seller_account_name.


## v0.6.0 (2015-04-06)

New API:

- Add Alipay::Service.mobile_security_pay_url.
- All service methods accept `options` args to config pid, seller_email and key.

New Config:

- Add `Alipay.sign_type`, default is 'MD5', allow: 'MD5', 'RSA'. 'DSA' is not implemented yet.

Break Changes:

- Move `Alipay::Service::Wap` to `Alipay::Wap::Service`
- Move `Alipay::Sign::Wap` to `Alipay::Wap::Sign`
- Move `Alipay::Notify::Wap` to `Alipay::Wap::Notify`
- Rename `Alipay::Service.create_forex_single_refund_url` to `Alipay::Service.forex_refund_url`
- Rename `Alipay::Service.create_forex_trade` to `Alipay::Service.create_forex_trade_url`
- Rename `Alipay::Service.create_refund_url` to `Alipay::Service.refund_fastpay_by_platform_pwd_url`
- Rename `Service::Wap.auth_and_execute` to `Service::Wap::Service.auth_and_execute_url`

Now `Alipay::Sign.verify?` and `Alipay::Wap::Sign.verify?` detect sign_type by params.

Development:

- Update Test::Unit to Minitest.
- Use fxied test data.

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
