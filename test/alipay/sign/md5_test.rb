require 'test_helper'

class Alipay::Sign::MD5Test < Minitest::Test
  def setup
    @string = "partner=123&service=test#{Alipay.key}"
    @sign = 'bbd13b52823b576291595f472ebcfbc2'
  end

  def test_sign
    assert_equal @sign, Alipay::Sign::MD5.sign(@string)
  end

  def test_verify
    assert Alipay::Sign::MD5.verify?(@string, @sign)
  end

  def test_verify_fail_when_sign_not_true
    assert !Alipay::Sign::MD5.verify?("danger#{@string}", @sign)
  end
end
