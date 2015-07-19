require 'test_helper'

class Alipay::Mobile::ServiceTest < Minitest::Test
  def test_mobile_securitypay_pay_string
    assert_equal %q(service="mobile.securitypay.pay"&_input_charset="utf-8"&partner="1000000000000000"&seller_id="1000000000000000"&payment_type="1"&out_trade_no="1"&notify_url="/some_url"&subject="subject"&total_fee="0.01"&body="test"&sign="if1qjK4qnT7eQ5fw%2BBddHhO1LY6iuPY9Xmhkx81YKuCdceKWBdv798j%2BrxF9ZAhNW4Y3TMURm%2BXpgxhOh8lj8vorFup%2BMJ6fe2rXRWgxFhK9B8xuP2XH%2F3878g6d8Jq2D2gINTgDDL7%2BB5%2FIWWlwInas40cQTsVngG8mWkzB788%3D"&sign_type="RSA"), Alipay::Mobile::Service.mobile_securitypay_pay_string({
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
