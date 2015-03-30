require 'test_helper'

class Alipay::Sign::MD5Test < Minitest::Test
  def setup
    @str = "partner=123&service=test#{Alipay.key}"
    @sign = 'bbd13b52823b576291595f472ebcfbc2'
  end

  def test_sign
    assert_equal @sign, Alipay::Sign::MD5.sign(@str)
  end

  def test_verify
    assert Alipay::Sign::MD5.verify?(@str, @sign)
  end

  def test_verify_fail_when_sign_not_true
    assert !Alipay::Sign::MD5.verify?("danger#{@str}", @sign)
  end
end
