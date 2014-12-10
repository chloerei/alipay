require 'test_helper'

class Alipay::ServiceTest < Test::Unit::TestCase
  def test_generate_create_partner_trade_by_buyer_url
    options = {
      :out_trade_no      => '1',
      :subject           => 'test',
      :logistics_type    => 'POST',
      :logistics_fee     => '0',
      :logistics_payment => 'SELLER_PAY',
      :price             => '0.01',
      :quantity          => 1
    }
    assert_not_nil Alipay::Service.create_partner_trade_by_buyer_url(options)
  end

  def test_generate_trade_create_by_buyer_url
    options = {
      :out_trade_no      => '1',
      :subject           => 'test',
      :logistics_type    => 'POST',
      :logistics_fee     => '0',
      :logistics_payment => 'SELLER_PAY',
      :price             => '0.01',
      :quantity          => 1
    }
    assert_not_nil Alipay::Service.trade_create_by_buyer_url(options)
  end

  def test_generate_create_direct_pay_by_user_url
    options = {
      :out_trade_no      => '1',
      :subject           => 'test',
      :price             => '0.01',
      :quantity          => 1
    }
    assert_not_nil Alipay::Service.create_direct_pay_by_user_url(options)
  end

  def test_generate_create_refund_url
    data = [{
      :trade_no => '1',
      :amount   => '0.01',
      :reason   => 'test'
    }]
    options = {
      :batch_no   =>  '123456789',
      :data       =>  data,
      :notify_url =>  '/some_url'
    }
    assert_not_nil Alipay::Service.create_refund_url(options)
  end

  def test_generate_create_forex_trade
    options = {
      :notify_url        => 'https://writings.io/orders/20130801000001/alipay_notify',
      :return_url        => 'https://writings.io/orders/20130801000001',
      :subject           => 'test',
      :out_trade_no      => '1',
      :currency          => 'EUR',
      :total_fee         => '0.0.1',
    }
    assert_not_nil Alipay::Service.create_forex_trade(options)
  end

  def test_close_trade
    response_body = <<-EOF
      <?xml version="1.0" encoding="utf-8"?>
      <alipay>
        <is_success>T</is_success>
      </alipay>
    EOF
    FakeWeb.register_uri(
      :get,
      %r|https://mapi\.alipay\.com/gateway\.do.*|,
      :body => response_body
    )

    assert_equal response_body, Alipay::Service.close_trade(
      :out_order_no => 'the-out-order-no'
    )
  end

  def test_should_send_goods_confirm_by_platform
    body = <<-EOF
      <?xml version="1.0" encoding="utf-8"?>
      <alipay>
        <is_success>T</is_success>
      </alipay>
    EOF
    FakeWeb.register_uri(
      :get,
      %r|https://mapi\.alipay\.com/gateway\.do.*|,
      :body => body
    )

    assert_equal body, Alipay::Service.send_goods_confirm_by_platform(
      :trade_no => 'trade_no_id',
      :logistics_name => 'writings.io',
      :transport_type => 'POST'
    )
  end
end
