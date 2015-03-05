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

  def test_generate_create_forex_single_refund_url
    options = {
      :out_return_no => '1',
      :out_trade_no  => '12345678980',
      :return_amount => 0.01,
      :currency      => 'USD',
      :reason        => '订单取消'
    }
    assert_not_nil Alipay::Service.create_forex_single_refund_url(options)
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

  def test_single_trade_query
    response_body = <<-EOF
      <?xml version="1.0" encoding="utf-8"?>
      <alipay>
        <is_success>T</is_success>
        <request>
          <param name="trade_no">20150123123123</param>
          <param name="_input_charset">utf-8</param>
          <param name="service">single_trade_query</param>
          <param name="partner">PARTNER</param>
        </request>
        <response>
          <trade>
            <additional_trade_status>DAEMON_CONFIRM_CLOSE</additional_trade_status>
            <buyer_email>foo@gmail.com</buyer_email>
            <buyer_id>BUYER_ID</buyer_id>
            <discount>0.00</discount>
            <flag_trade_locked>0</flag_trade_locked>
            <gmt_close>2015-01-20 02:37:00</gmt_close>
            <gmt_create>2015-01-20 02:17:00</gmt_create>
            <gmt_last_modified_time>2015-01-20 02:37:00</gmt_last_modified_time>
            <is_total_fee_adjust>F</is_total_fee_adjust>
            <operator_role>B</operator_role>
            <out_trade_no>OUT_TRADE_NO</out_trade_no>
            <payment_type>1</payment_type>
            <price>640.00</price>
            <quantity>1</quantity>
            <seller_email>bar@gmail.com</seller_email>
            <seller_id>SELLER_ID</seller_id>
            <subject>ORDER SUBJECT</subject>
            <to_buyer_fee>0.00</to_buyer_fee>
            <to_seller_fee>0.00</to_seller_fee>
            <total_fee>640.00</total_fee>
            <trade_no>TRADE_NO</trade_no>
            <trade_status>TRADE_CLOSED</trade_status>
            <use_coupon>F</use_coupon>
            </trade></response>
            <sign>SIGN</sign>
            <sign_type>MD5</sign_type>
          </alipay>
    EOF
    FakeWeb.register_uri(
      :get,
      %r|https://mapi\.alipay\.com/gateway\.do.*|,
      :body => response_body
    )

    assert_equal response_body, Alipay::Service.single_trade_query(
      :out_trade_no => 'the-out-trade-no'
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
