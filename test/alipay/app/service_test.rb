require 'test_helper'

class Alipay::Mobile::ServiceTest < Minitest::Test
  def setup
    base_params = {
      app_id: '2015052600090779',
      biz_content: {:timeout_express=>"30m",:seller_id=>"",:product_code=>"QUICK_MSECURITY_PAY",:total_amount=>"0.01",:subject=>"1",:body=>"我是测试数据",:out_trade_no=>"IQJZSRC1YMQB5HU"}.to_json,
      charset: 'utf-8',
      format: 'json',
      method: 'alipay.trade.app.pay',
      notify_url: 'http://domain.merchant.com/payment_notify',
      timestamp: '2016-08-25 20:26:31',
      version: '1.0'
    }
    @rsa_sign_params  = base_params.merge(sign_type: 'RSA')
    @rsa2_sign_params = base_params.merge(sign_type: 'RSA2')

    @rsa_pkey  = OpenSSL::PKey::RSA.new(1024)
    @rsa2_pkey = OpenSSL::PKey::RSA.new(2048)

    @rsa_sign  = Base64.strict_encode64(@rsa_pkey .sign('sha1'  , @rsa_sign_params. sort.map{ |k,v| %Q(#{k}=#{v}) }.join('&')))
    @rsa2_sign = Base64.strict_encode64(@rsa2_pkey.sign('sha256', @rsa2_sign_params.sort.map{ |k,v| %Q(#{k}=#{v}) }.join('&')))
  end

  def test_mobile_securitypay_pay_string_with_rsa
      encoded_str = Alipay::App::Service.alipay_trade_app_pay(@rsa_sign_params , sign_type: 'RSA' , key: @rsa_pkey.export)
      params = Hash[ URI.decode_www_form(encoded_str).map {|(k,v)| [k.to_sym, v] } ]
      sign = params.delete(:sign)
      assert_equal sign, @rsa_sign
      assert_equal params, @rsa_sign_params
  end

  def test_mobile_securitypay_pay_string_with_rsa2
      encoded_str = Alipay::App::Service.alipay_trade_app_pay(@rsa2_sign_params, sign_type: 'RSA2', key: @rsa2_pkey.export)
      params = Hash[ URI.decode_www_form(encoded_str).map {|(k,v)| [k.to_sym, v] } ]
      sign = params.delete(:sign)
      assert_equal sign, @rsa2_sign
      assert_equal params, @rsa2_sign_params
  end
end
