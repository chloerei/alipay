require 'test_helper'

class Alipay::Service::WapTest < Minitest::Test
  def test_trade_create_direct_token
    token = 'REQUEST_TOKEN'
    body = <<-EOS
      res_data=
        <?xmlversion="1.0" encoding="utf-8"?>
        <direct_trade_create_res>
          <request_token>#{token}</request_token>
        </direct_trade_create_res>
      &partner=PID
      &req_id=REQ_ID
      &sec_id=MD5
      &service=alipay.wap.trade.create.direct
      &v=2.0
      &sign=SIGN
    EOS

    FakeWeb.register_uri(
      :get,
      %r|https://wappaygw\.alipay\.com/service/rest\.htm.*|,
      :body => body
    )

    assert_equal token, Alipay::Service::Wap.trade_create_direct_token(
      :req_data => {
        :out_trade_no  => '1',
        :subject       => 'subject',
        :total_fee     => '0.01',
        :call_back_url => 'https://example.com/call_back'
      }
    )
  end

  def test_auth_and_execute_url
    params = { :request_token => 'token_test' }
    assert_equal 'https://wappaygw.alipay.com/service/rest.htm?service=alipay.wap.auth.authAndExecute&req_data=%3Cauth_and_execute_req%3E%3Crequest_token%3Etoken_test%3C%2Frequest_token%3E%3C%2Fauth_and_execute_req%3E&partner=1000000000000000&format=xml&v=2.0&sec_id=MD5&sign=3efe60d4a9b7960ba599da6764c959df', Alipay::Service::Wap.auth_and_execute_url(params)
  end
end
