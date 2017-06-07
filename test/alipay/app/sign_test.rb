require 'test_helper'
require 'base64'

class Alipay::App::SignTest < Minitest::Test
  def setup
    @params = {
      biz_content: {:name=>'顺道'}.to_json,
      out_trade_no: 'MEM1234567',
      total_amount: '0.01'
    }

    @rsa_pkey = OpenSSL::PKey::RSA.new(1024)
    @rsa2_pkey = OpenSSL::PKey::RSA.new(2048)
  end

  def test_params_to_sorted_string
    assert_equal %q(a=2&b=1), Alipay::App::Sign.params_to_sorted_string(b: 1, a: 2)
  end

  def test_params_to_encoded_string
    assert_equal %q(biz_content=%7B%22name%22%3A%22%E9%A1%BA%E9%81%93%22%7D&out_trade_no=MEM1234567&total_amount=0.01), Alipay::App::Sign.params_to_encoded_string(@params)
  end

  def test_verify_with_rsa2
    string = Alipay::App::Sign.params_to_sorted_string(@params)
    sign = Base64.strict_encode64(@rsa2_pkey.sign('sha256', string))
    params = @params.merge(sign: sign, sign_type: 'RSA2')

    assert Alipay::App::Sign.verify?(params, sign_type: :rsa2, key: @rsa2_pkey.public_key.export)
  end

  def test_verify_with_rsa
    string = Alipay::App::Sign.params_to_sorted_string(@params)
    sign = Base64.strict_encode64(@rsa_pkey.sign('sha1', string))
    params = @params.merge(sign: sign, sign_type: 'RSA')

    assert Alipay::App::Sign.verify?(params, sign_type: :rsa, key: @rsa_pkey.public_key.export)
  end
end
