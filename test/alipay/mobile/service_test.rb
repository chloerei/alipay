require 'test_helper'

class Alipay::Mobile::ServiceTest < Minitest::Test
  def test_mobile_securitypay_pay_string
    assert_equal %q(service="mobile.securitypay.pay"&_input_charset="utf-8"&partner="1000000000000000"&seller_id="1000000000000000"&payment_type="1"&out_trade_no="1"&notify_url="/some_url"&subject="subject"&total_fee="0.01"&body="test"&sign="if1qjK4qnT7eQ5fw+BddHhO1LY6iuPY9Xmhkx81YKuCdceKWBdv798j+rxF9ZAhNW4Y3TMURm+XpgxhOh8lj8vorFup+MJ6fe2rXRWgxFhK9B8xuP2XH/3878g6d8Jq2D2gINTgDDL7+B5/IWWlwInas40cQTsVngG8mWkzB788="&sign_type="RSA"), Alipay::Mobile::Service.mobile_securitypay_pay_string({
      out_trade_no: '1',
      notify_url: '/some_url',
      subject: 'subject',
      total_fee: '0.01',
      body: 'test'
    }, {
      sign_type: 'RSA',
      key: TEST_RSA_PRIVATE_KEY
    })
  end
end
