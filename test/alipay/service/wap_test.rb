require 'test_helper'

class Alipay::Service::WapTest < Test::Unit::TestCase
  def test_trade_create_direct_token
    body = <<-EOS
      res_data=
        <?xmlversion="1.0" encoding="utf-8"?>
        <direct_trade_create_res>
          <request_token>REQUEST_TOKEN</request_token>
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

    assert_equal body, Alipay::Service::Wap.trade_create_direct_token(
      :req_data => {
        :out_trade_no  => '1',
        :subject       => 'subject',
        :total_fee     => '0.01',
        :call_back_url => 'http://www.yoursite.com/call_back'
      }
    )
  end

  def test_auth_and_execute
    options = { :request_token => 'token_test' }
    assert_not_nil Alipay::Service::Wap.auth_and_execute(options)
  end
end
