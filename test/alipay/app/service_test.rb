require 'test_helper'

class Alipay::Mobile::ServiceTest < Minitest::Test
  def test_mobile_securitypay_pay_string
    assert_equal %q(app_id=2015052600090779&biz_content=%7B%3Atimeout_express%3D%3E%2230m%22%2C%20%3Aseller_id%3D%3E%22%22%2C%20%3Aproduct_code%3D%3E%22QUICK_MSECURITY_PAY%22%2C%20%3Atotal_amount%3D%3E%220.01%22%2C%20%3Asubject%3D%3E%221%22%2C%20%3Abody%3D%3E%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%20%3Aout_trade_no%3D%3E%22IQJZSRC1YMQB5HU%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fdomain.merchant.com%2Fpayment_notify&sign_type=RSA&timestamp=2016-08-25%2020%3A26%3A31&version=1.0&sign=lT%2BwWRpKYDP4QLm8Ore6ngGQv8aHGPw1OuI2e8pRf5aWO55sTAYqN01uJyKDe3Swzat8UYdvby8o9haA3LPQibYXB2sezkZxOBHpfdKVRjXe0u9qTMlACAQUQLQeXQFNfcWRgKUGNLMHARv7ajqz8tCnDN2B3mlAmKs0r4qb6IM%3D), Alipay::App::Service.alipay_trade_app_pay({
      app_id: '2015052600090779',
      biz_content: {:timeout_express=>"30m",:seller_id=>"",:product_code=>"QUICK_MSECURITY_PAY",:total_amount=>"0.01",:subject=>"1",:body=>"我是测试数据",:out_trade_no=>"IQJZSRC1YMQB5HU"},
      charset: 'utf-8',
      format: 'json',
      method: 'alipay.trade.app.pay',
      notify_url: 'http://domain.merchant.com/payment_notify',
      sign_type: 'RSA',
      timestamp: '2016-08-25 20:26:31',
      version: '1.0'
    }, {
      sign_type: 'RSA',
      key: TEST_RSA_PRIVATE_KEY
    })
  end
end
