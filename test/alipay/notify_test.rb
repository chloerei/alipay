require 'test_helper'

class Alipay::NotifyTest < Test::Unit::TestCase
  def test_verify_notify_when_true
    FakeWeb.register_uri(:get, "http://notify.alipay.com/trade/notify_query.do?partner=#{Alipay.pid}&notify_id=true_id", :body => "true")
    assert Alipay::Notify.verify?(:notify_id => 'true_id')
  end

  def test_verify_notify_when_false
    FakeWeb.register_uri(:get, "http://notify.alipay.com/trade/notify_query.do?partner=#{Alipay.pid}&notify_id=fake_id", :body => "false")
    assert !Alipay::Notify.verify?(:notify_id => 'fake_id')
  end
end
