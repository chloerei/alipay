require 'test_helper'

class Alipay::SignTest < Test::Unit::TestCase
  def setup
    @params = {
      :service => 'test',
      :partner => '123'
    }
    @sign = Digest::MD5.hexdigest("partner=123&service=test#{Alipay.key}")
  end

  def test_generate_sign
    assert_equal @sign, Alipay::Sign.generate(@params)
  end

  def test_verify_sign
    assert Alipay::Sign.verify?(@params.merge(:sign => @sign))
  end

  def test_verify_sign_when_fails
    assert !Alipay::Sign.verify?(@params.merge(:danger => 'danger', :sign => @sign))
  end
end
