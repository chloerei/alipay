require 'test_helper'

class Alipay::ServiceTest < Minitest::Test
  def test_generate_create_partner_trade_by_buyer_url
    options = {
      out_trade_no: '1',
      subject: 'test',
      logistics_type: 'POST',
      logistics_fee: '0',
      logistics_payment: 'SELLER_PAY',
      price: '0.01',
      quantity: 1
    }

    assert_equal 'https://mapi.alipay.com/gateway.do?service=create_partner_trade_by_buyer&_input_charset=utf-8&partner=1000000000000000&seller_id=1000000000000000&payment_type=1&out_trade_no=1&subject=test&logistics_type=POST&logistics_fee=0&logistics_payment=SELLER_PAY&price=0.01&quantity=1&sign_type=MD5&sign=b5d30863b44acd8514a49b0320fb2aa2', Alipay::Service.create_partner_trade_by_buyer_url(options)
  end

  def test_generate_trade_create_by_buyer_url
    options = {
      out_trade_no: '1',
      subject: 'test',
      logistics_type: 'POST',
      logistics_fee: '0',
      logistics_payment: 'SELLER_PAY',
      price: '0.01',
      quantity: 1
    }
    assert_equal 'https://mapi.alipay.com/gateway.do?service=trade_create_by_buyer&_input_charset=utf-8&partner=1000000000000000&seller_id=1000000000000000&payment_type=1&out_trade_no=1&subject=test&logistics_type=POST&logistics_fee=0&logistics_payment=SELLER_PAY&price=0.01&quantity=1&sign_type=MD5&sign=2d296368fea70a127da939558c970bab', Alipay::Service.trade_create_by_buyer_url(options)
  end

  def test_generate_create_direct_pay_by_user_url
    options = {
      out_trade_no: '1',
      subject: 'test',
      price: '0.01',
      quantity: 1
    }
    assert_equal 'https://mapi.alipay.com/gateway.do?service=create_direct_pay_by_user&_input_charset=utf-8&partner=1000000000000000&seller_id=1000000000000000&payment_type=1&out_trade_no=1&subject=test&price=0.01&quantity=1&sign_type=MD5&sign=682ad02280fca7d4c0fd22678fdddeef', Alipay::Service.create_direct_pay_by_user_url(options)
  end

  def test_generate_create_direct_pay_by_user_wap_url
    options = {
      out_trade_no: '1',
      subject: 'test',
      total_fee: '0.01'
    }
    assert_equal 'https://mapi.alipay.com/gateway.do?service=alipay.wap.create.direct.pay.by.user&_input_charset=utf-8&partner=1000000000000000&seller_id=1000000000000000&payment_type=1&out_trade_no=1&subject=test&total_fee=0.01&sign_type=MD5&sign=6530de6e3cba153cd4ca7edc48b91f96', Alipay::Service.create_direct_pay_by_user_wap_url(options)
  end

  def test_refund_fastpay_by_platform_pwd_url
    data = [{
      trade_no: '1',
      amount: '0.01',
      reason: 'test'
    }]
    options = {
      batch_no: '123456789',
      data: data,
      notify_url: '/some_url',
      refund_date: '2015-01-01 00:00:00'
    }
    assert_equal 'https://mapi.alipay.com/gateway.do?service=refund_fastpay_by_platform_pwd&_input_charset=utf-8&partner=1000000000000000&seller_user_id=1000000000000000&refund_date=2015-01-01+00%3A00%3A00&batch_num=1&detail_data=1%5E0.01%5Etest&batch_no=123456789&notify_url=%2Fsome_url&sign_type=MD5&sign=def57a58e1ac21f70c45e41bd3697368', Alipay::Service.refund_fastpay_by_platform_pwd_url(options)
  end

  def test_forex_refund_url
    options = {
      out_return_no: '1',
      out_trade_no: '12345678980',
      return_amount: '0.01',
      currency: 'USD',
      reason: 'reason',
      gmt_return: '20150101000000'
    }
    assert_equal 'https://mapi.alipay.com/gateway.do?service=forex_refund&partner=1000000000000000&_input_charset=utf-8&gmt_return=20150101000000&out_return_no=1&out_trade_no=12345678980&return_amount=0.01&currency=USD&reason=reason&sign_type=MD5&sign=c9681fff5505fe993d1b2b8141308d0d', Alipay::Service.forex_refund_url(options)
  end

  def test_generate_create_forex_trade_url
    options = {
      notify_url: 'https://example.com/notify',
      subject: 'test',
      out_trade_no: '1',
      currency: 'EUR',
      total_fee: '0.01',
    }
    assert_equal 'https://mapi.alipay.com/gateway.do?service=create_forex_trade&_input_charset=utf-8&partner=1000000000000000&notify_url=https%3A%2F%2Fexample.com%2Fnotify&subject=test&out_trade_no=1&currency=EUR&total_fee=0.01&sign_type=MD5&sign=f24fd4d76acabf860263a40805138380', Alipay::Service.create_forex_trade_url(options)
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
      body: response_body
    )

    assert_equal response_body, Alipay::Service.close_trade(
      out_order_no: '1'
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
            <buyer_email>buyer@example.com</buyer_email>
            <buyer_id>BUYER_ID</buyer_id>
            <discount>0.00</discount>
            <flag_trade_locked>0</flag_trade_locked>
            <gmt_close>2015-01-20 02:37:00</gmt_close>
            <gmt_create>2015-01-20 02:17:00</gmt_create>
            <gmt_last_modified_time>2015-01-20 02:37:00</gmt_last_modified_time>
            <is_total_fee_adjust>F</is_total_fee_adjust>
            <operator_role>B</operator_role>
            <out_trade_no>1</out_trade_no>
            <payment_type>1</payment_type>
            <price>640.00</price>
            <quantity>1</quantity>
            <seller_email>seller@example.com</seller_email>
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
      body: response_body
    )

    assert_equal response_body, Alipay::Service.single_trade_query(
      out_trade_no: '1'
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
      body: body
    )

    assert_equal body, Alipay::Service.send_goods_confirm_by_platform(
      trade_no: 'trade_no',
      logistics_name: 'example.com',
      transport_type: 'DIRECT'
    )
  end

  def test_account_page_query
    body = <<-EOF
      <?xml version="1.0" encoding="utf-8"?>
      <alipay>
        <is_success>T</is_success>
        <request>
          <param name="sign">sign_data</param>
          <param name="_input_charset">utf-8</param>
          <param name="gmt_end_time">2015-10-26 06:20:29</param>
          <param name="sign_type">MD5</param>
          <param name="service">account.page.query</param>
          <param name="partner">2088123123</param>
          <param name="page_no">1</param>
          <param name="gmt_start_time">2015-10-25 06:20:29</param>
        </request>
        <response>
          <account_page_query_result>
            <account_log_list>
              <AccountQueryAccountLogVO>
                <balance>1234</balance>
                <buyer_account>2088123123</buyer_account>
                <currency>123</currency>
                <deposit_bank_no>20151025123123</deposit_bank_no>
                <goods_title>商品名称</goods_title>
                <income>100.00</income>
                <iw_account_log_id>12345678910</iw_account_log_id>
                <memo> </memo>
                <merchant_out_order_no>1234567</merchant_out_order_no>
                <outcome>0.00</outcome>
                <partner_id>2088123123</partner_id>
                <rate>0.015</rate>
                <seller_account>2088123123123</seller_account>
                <seller_fullname>xxxx有限公司</seller_fullname>
                <service_fee>0.00</service_fee>
                <service_fee_ratio> </service_fee_ratio>
                <sign_product_name>快捷手机安全支付</sign_product_name>
                <sub_trans_code_msg>快速支付,支付给个人，支付宝帐户全额</sub_trans_code_msg>
                <total_fee>100.00</total_fee>
                <trade_no>20151025123123</trade_no>
                <trade_refund_amount>0.00</trade_refund_amount>
                <trans_code_msg>在线支付</trans_code_msg>
                <trans_date>2015-10-25 06:33:07</trans_date>
              </AccountQueryAccountLogVO>
            </account_log_list>
            <has_next_page>F</has_next_page>
            <page_no>1</page_no>
            <page_size>5000</page_size>
          </account_page_query_result>
        </response>
        <sign>sign_data</sign>
        <sign_type>MD5</sign_type>
      </alipay>
    EOF
    FakeWeb.register_uri(:get, %r|https://mapi\.alipay\.com/gateway\.do.*|, :body => body)

    assert_equal body, Alipay::Service.account_page_query(
      page_no: 1,
      gmt_start_time: (Time.now - 1).strftime('%Y-%m-%d %H:%M:%S'),
      gmt_end_time: Time.now.strftime('%Y-%m-%d %H:%M:%S')
    )
  end
end
