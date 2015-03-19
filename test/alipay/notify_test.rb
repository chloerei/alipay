require 'test_helper'

class Alipay::NotifyTest < Minitest::Test
  def setup
    @options = {
      :notify_id => '1234'
    }
    @sign_options = @options.merge(:sign_type => 'MD5', :sign => Alipay::Sign.generate(@options))
  end

  def test_unsign_notify
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", :body => "true")
    assert !Alipay::Notify.verify?(@options)
  end

  def test_verify_notify_when_true
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", :body => "true")
    assert Alipay::Notify.verify?(@sign_options)
  end

  def test_verify_notify_when_false
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", :body => "false")
    assert !Alipay::Notify.verify?(@sign_options)
  end
end
