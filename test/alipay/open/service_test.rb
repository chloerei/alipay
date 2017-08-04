require 'json'

class Alipay::Open::ServiceTest < Minitest::Test

  def test_alipay_system_oauth_token_url
    params = {
      code: '4b203fe6c11548bcabd8da5bb087a83b'
    }

    resp = {
      "alipay_system_oauth_token_response": {
          "access_token": "publicpBa869cad0990e4e17a57ecf7c5469a4b2",
          "user_id": "2088411964574197",
          "alipay_user_id": "20881007434917916336963360919773",
          "expires_in": 300,
          "re_expires_in": 300,
          "refresh_token": "publicpB0ff17e364f0743c79b0b0d7f55e20bfc"
      },
      "sign": "xDffQVBBelDiY/FdJi4/a2iQV1I7TgKDFf/9BUCe6+l1UB55YDOdlCAir8CGlTfa0zLYdX0UaYAa43zY2jLhCTDG+d6EjhCBWsNY74yTdiM95kTNsREgAt4PkOkpsbyZVXdLIShxLFAqI49GIv82J3YtzBcVDDdDeqFcUhfasII="
    }.to_json

    stub_request(:get, %r|openapi\.alipay\.com|).
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'openapi.alipay.com', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: resp, headers: {})

    ret = JSON.parse(Alipay::Open::Service.alipay_system_oauth_token_url(params, { sign_type: 'rsa', app_service_id: '10000000000000', service_key: TEST_RSA_PRIVATE_KEY }))

    assert ret["sign"]
  end

  def test_alipay_user_info_share_url
    params = {
      auth_token: '201208134b203fe6c11548bcabd8da5bb087a83b'
    }

    resp = {
      "alipay_user_info_share_response": {
          "avatar": "https:\/\/tfsimg.alipay.com\/images\/partner\/T1k0xiXXRnXXXXXXXX",
          "nick_name": "张三",
          "city": "杭州",
          "province": "浙江省",
          "gender": "M",
          "user_type_value": "2",
          "is_licence_auth": "F",
          "is_certified": "T",
          "is_certify_grade_a": "T",
          "is_student_certified": "F",
          "is_bank_auth": "T",
          "is_mobile_auth": "T",
          "alipay_user_id": "2088102015433735",
          "user_id": "20881007434917916336963360919773",
          "user_status": "T",
          "is_id_auth": "T"
      },
      "sign": "jhoSkfE7BTIbwEx0L8/H0GU0Z2DOZYIJlrUMyJL8wwwInVeXfz+CWqx0V2b3FvhMQSrb74dkzDQpGXGdZQZMldGe4+FSEQU1V3tWijpO9ZisNJnEpF+U2lQ7IUMLsgjjx9a0IdMwvXlqz1HPrmFZQjG2dvlFyXhi07HcEnVOJZw="
    }.to_json

    stub_request(:get, %r|openapi\.alipay\.com|).
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'openapi.alipay.com', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: resp, headers: {})

    ret = JSON.parse(Alipay::Open::Service.alipay_user_info_share_url(params, { sign_type: 'rsa', app_service_id: '10000000000000', service_key: TEST_RSA_PRIVATE_KEY }))

    assert ret["sign"]
  end

  def test_alipay_fund_trans_toaccount_transfer
    biz_content = {
      'out_biz_no' => 'OUT_BIZ_NO',
      'payee_type' => 'ALIPAY_LOGONID',
      'payee_account' => 'hi@example.com',
      'amount' => 10.00,
      'payer_show_name' => 'payer show namep',
      'payee_real_name' => 'real name',
      'remark' => 'remark'
    }

    resp = {
      "sign" => "ERITJKEIJKJHKKKKKKKHJEREEEEEEEEEEE",
      "alipay_fund_trans_toaccount_transfer_response" => {
        "pay_date" => "2013-01-01 08:08:08",
        "code" => "10000",
        "order_id" => "20160627110070001502260006780837",
        "msg" => "Success",
        "out_biz_no" => "3142321423432"
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
