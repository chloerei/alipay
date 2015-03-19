require 'test_helper'

class Alipay::Sign::WapTest < Minitest::Test
  def setup
    @params = {
      :v => '1.0',
      :sec_id => 'MD5',
      :service => 'test',
      :notify_data => 'notify_data'
    }
    @sign = Digest::MD5.hexdigest("service=test&v=1.0&sec_id=MD5&notify_data=notify_data#{Alipay.key}")
  end

  def test_verify_sign
    assert Alipay::Sign::Wap.verify?(@params.merge(:sign => @sign, :whatever => 'x'))
  end
end
