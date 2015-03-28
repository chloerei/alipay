require 'test_helper'

class Alipay::NotifyTest < Minitest::Test
  def setup
    @params = {
      :notify_id => '1234',
    }
    @unsign_params = @params.merge(:sign_type => 'MD5', :sign => 'xxxx')
    @sign_params = @params.merge(
      :sign_type => 'MD5',
      :sign      => '22fc7e38e5acdfede396aa463870d111'
    )
  end

  def test_unsign_notify
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", :body => "true")
    assert !Alipay::Notify.verify?(@unsign_params)
  end

  def test_verify_notify_when_true
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", :body => "true")
    assert Alipay::Notify.verify?(@sign_params)
  end

  def test_verify_notify_when_false
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=1234", :body => "false")
    assert !Alipay::Notify.verify?(@sign_params)
  end
end
