require 'test_helper'

class Alipay::Mobile::ServiceTest < Minitest::Test
  def setup
    @params = {
      app_id: '2016000000000000',
      biz_content: {
        timeout_express: "30m",
        seller_id: "",
        product_code: "QUICK_MSECURITY_PAY",
        total_amount: "0.01",
        subject: "1",
        body: "测试数据",
        out_trade_no: "10000000"
      }.to_json,
      charset: 'utf-8',
      format: 'json',
      method: 'alipay.trade.app.pay',
      notify_url: 'http://example.com/notify',
      timestamp: '2016-08-25 20:26:31',
      version: '1.0'
    }
  end

  def test_alipay_trade_app_pay_with_rsa
      assert_equal 'app_id=2016000000000000&biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22seller_id%22%3A%22%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.01%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%2210000000%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fexample.com%2Fnotify&sign=Cvie7tAzUCH1JF7gVM2jMuEJ2%2FdHGWQesyl4MyV6MWnTeGzWhB4fgCJ%2B7EbdurHfiOVRpnGZkYc6twoWP53P2S6K4fp%2BazUJLVBgpSFy9ufn9Sf4BLpWMeOOEt5ufWdoWxWALhTbeEZnZReTDR1S%2FEXKw%2FTdjMWc3Q0kcG4ARzQ%3D&sign_type=RSA&timestamp=2016-08-25%2020%3A26%3A31&version=1.0', Alipay::App::Service.alipay_trade_app_pay(@params, sign_type: 'RSA' , key: TEST_RSA_PRIVATE_KEY)
  end

  def test_alipay_trade_app_pay_with_rsa2
      assert_equal 'app_id=2016000000000000&biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22seller_id%22%3A%22%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.01%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%2210000000%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fexample.com%2Fnotify&sign=fRBLfmUFXDRWW%2BtWD7BQlv8uymKU7Ky8TQKLF%2FnGkUsdCXnZ0MbqLFXAoE4Il6464n9YKncJhG50aDZ4s4HxpMMCku55so99nPkf3Uoksmje5Z5zSZusxnUHl5o7zf21%2BIOOf5mJzA%2Fp4BGZqFK00CoM07Ye9tSV%2Fid1hT8MbxA%3D&sign_type=RSA2&timestamp=2016-08-25%2020%3A26%3A31&version=1.0', Alipay::App::Service.alipay_trade_app_pay(@params, sign_type: 'RSA2' , key: TEST_RSA_PRIVATE_KEY)
  end
end
