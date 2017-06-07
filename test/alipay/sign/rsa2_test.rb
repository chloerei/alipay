require 'test_helper'

class Alipay::Sign::RSA2Test < Minitest::Test
  def setup
    @string = "partner=123&service=test"
    @rsa2_pkey = OpenSSL::PKey::RSA.new(2048)
    @rsa2_public_key = @rsa2_pkey.public_key.export
    @sign = Base64.strict_encode64(@rsa2_pkey.sign('sha256', @string))
  end

  def test_sign
    assert_equal @sign, Alipay::Sign::RSA2.sign(@rsa2_pkey, @string)
  end

  def test_verify
    assert Alipay::Sign::RSA2.verify?(@rsa2_public_key, @string, @sign)
  end

  def test_verify_fail_when_sign_not_true
    assert !Alipay::Sign::RSA2.verify?(@rsa2_public_key, "danger#{@string}", @sign)
  end
end
