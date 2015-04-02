require 'test_helper'

class Alipay::SignTest < Minitest::Test
  def setup
    @params = {
      :service => 'test',
      :partner => '123'
    }
    @md5_sign = 'bbd13b52823b576291595f472ebcfbc2'

    @key_2 = '20000000000000000000000000000000'
    @md5_sign_2 = '6d581af270c023fdaaca6880491e9bf7'
  end

  def test_generate_sign
    assert_equal @md5_sign, Alipay::Sign.generate(@params)
    assert_equal @md5_sign_2, Alipay::Sign.generate(@params, {:key => @key_2})
  end

  def test_verify_sign
    assert Alipay::Sign.verify?(@params.merge(:sign_type => 'MD5', :sign => @md5_sign))
    assert Alipay::Sign.verify?(@params.merge(:sign_type => 'MD5', :sign => @md5_sign_2), {:key => @key_2})
  end

  def test_verify_fail_when_sign_not_true
    assert !Alipay::Sign.verify?(@params)
    assert !Alipay::Sign.verify?(@params.merge(:danger => 'danger', :sign_type => 'MD5', :sign => @md5_sign))
    assert !Alipay::Sign.verify?(@params.merge(:sign_type => 'MD5', :sign => 'danger'))
  end
end
