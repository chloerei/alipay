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

  def test_should_generate_trade_create_by_buyer_url
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
