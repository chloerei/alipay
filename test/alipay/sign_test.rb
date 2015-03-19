require 'test_helper'

class Alipay::SignTest < Minitest::Test
  def setup
    @params = {
      :service => 'test',
      :partner => '123'
    }
    @md5_sign = Digest::MD5.hexdigest("partner=123&service=test#{Alipay.key}")
  end

  def test_generate_sign
    assert_equal @md5_sign, Alipay::Sign.generate(@params)
  end

  def test_generate_md5_sign
    assert_equal @md5_sign, Alipay::Sign.generate_md5(@params)
  end

  def test_verify_sign
    assert Alipay::Sign.verify?(@params.merge(:sign => @md5_sign))
  end

  def test_verify_sign_when_fails
    assert !Alipay::Sign.verify?(@params.merge(:danger => 'danger', :sign => @md5_sign))
  end
end
