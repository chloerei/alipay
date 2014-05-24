require 'test_helper'

class Alipay::Notify::WapTest < Test::Unit::TestCase
  def setup
    @notify_params = {
      :notify_id => 1234,
      :v => '1.0',
      :sec_id => 'MD5',
      :service => 'service',
      :notify_data => '<notify><notify_id>1234</notify_id></notify>'
    }

    query = [ :service, :v, :sec_id, :notify_data ].map {|key| "#{key}=#{@notify_params[key]}"}.join('&')
    @sign_params = @notify_params.merge(:sign => Digest::MD5.hexdigest("#{query}#{Alipay.key}"))
  end

  def test_unsign_notify
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", :body => "true")
    assert !Alipay::Notify::Wap.verify?(@notify_params)
  end

  def test_verify_notify_when_true
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", :body => "true")
    assert Alipay::Notify::Wap.verify?(@sign_params)
  end

  def test_verify_notify_when_false
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", :body => "false")
    assert !Alipay::Notify::Wap.verify?(@sign_params)
  end
end
