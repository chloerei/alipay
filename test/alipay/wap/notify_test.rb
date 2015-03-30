require 'test_helper'

class Alipay::Wap::NotifyTest < Minitest::Test
  def setup
    @notify_id = 'notify_id_test'

    @notify_params = {
      :service => 'alipay.wap.trade.create.direct',
      :v => '1.0',
      :sec_id => 'MD5',
      :notify_data => "<notify><notify_id>#{@notify_id}</notify_id><other_key>other_value</other_key></notify>"
    }

    query = [ :service, :v, :sec_id, :notify_data ].map {|key| "#{key}=#{@notify_params[key]}"}.join('&')
    @sign_params = @notify_params.merge(:sign => Digest::MD5.hexdigest("#{query}#{Alipay.key}"))
  end

  def test_unsign_notify
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=#{@notify_id}", :body => "true")
    assert !Alipay::Wap::Notify.verify?(@notify_params)
  end

  def test_verify_notify_when_true
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=#{@notify_id}", :body => "true")
    assert Alipay::Wap::Notify.verify?(@sign_params)
  end

  def test_verify_notify_when_false
    FakeWeb.register_uri(:get, "https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=#{@notify_id}", :body => "false")
    assert !Alipay::Wap::Notify.verify?(@sign_params)
  end
end
