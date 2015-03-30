require 'test_helper'

class Alipay::Sign::MD5Test < Minitest::Test
  def setup
    @string = "partner=123&service=test"
    @sign = 'bbd13b52823b576291595f472ebcfbc2'
  end

  def test_sign
    assert_equal @sign, Alipay::Sign::MD5.sign(Alipay.key, @string)
  end

  def test_verify
    assert Alipay::Sign::MD5.verify?(Alipay.key, @string, @sign)
  end

  def test_verify_fail_when_sign_not_true
    assert !Alipay::Sign::MD5.verify?(Alipay.key, "danger#{@string}", @sign)
  end
end
