class Alipay::Open::ServiceTest < Minitest::Test

  def test_alipay_fund_trans_toaccount_transfer
    biz_content = {
      'out_biz_no': 'OUT_BIZ_NO',
      'payee_type': 'ALIPAY_LOGONID',
      'payee_account': 'hi@example.com',
      'amount': 10.00,
      'payer_show_name': 'payer show namep',
      'payee_real_name': 'real name',
      'remark': 'remark'
    }

    resp = {
      "sign":"ERITJKEIJKJHKKKKKKKHJEREEEEEEEEEEE",
      "alipay_fund_trans_toaccount_transfer_response":{
        "pay_date":"2013-01-01 08:08:08",
        "code":"10000",
        "order_id":"20160627110070001502260006780837",
        "msg":"Success",
        "out_biz_no":"3142321423432"
      }
    }.to_json

    stub_request(:get, %r|openapi\.alipay\.com|).
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'openapi.alipay.com', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: resp, headers: {})

    ret = JSON.parse(Alipay::Open::Service.alipay_fund_trans_toaccount_transfer(biz_content, { sign_type: 'rsa', key: TEST_RSA_PRIVATE_KEY }))
    assert ret["sign"]
  end

  def test_alipay_trade_wap_pay_url
    assert Alipay::Open::Service.alipay_trade_wap_pay_url({
      out_trade_no: 'OUT_TRADE_NO',
      subject: 'REMARK',
      total_amount: 10.00,
      return_url: "http://example.com/alipay/payment_successful",
      notify_url: "http://example.com/payment_notifications/alipay",
      product_code: 'QUICK_WAP_PAY'
    }, { sign_type: 'rsa', key: TEST_RSA_PRIVATE_KEY })
  end

end
