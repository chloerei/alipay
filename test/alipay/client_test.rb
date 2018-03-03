require 'test_helper'

class Alipay::ClientTest < Minitest::Test
  def setup
    @client = Alipay::Client.new(
      url: 'https://openapi.alipaydev.com/gateway.do',
      app_id: '2016000000000000',
      app_private_key: TEST_RSA_PRIVATE_KEY,
      format: 'json',
      charset: 'UTF-8',
      alipay_public_key: TEST_RSA_PUBLIC_KEY,
      sign_type: 'RSA2'
    )
  end

  def test_client_initialize
    refute_nil @client
  end

  def test_sdk_execute_for_alipay_trade_app_pay
    string = 'app_id=2016000000000000&charset=UTF-8&sign_type=RSA2&version=1.0&timestamp=2016-04-01+00%3A00%3A00&method=alipay.trade.page.pay&biz_content=%7B%22out_trade_no%22%3A%2220160401000000%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.01%22%2C%22subject%22%3A%22test%22%7D&sign=NbpUhRJ0HYSSIQGPxHOVLQpHcvzOyN8%2FeIhxq26Gglpx2%2BQvsJdffxg8bySiVcXryiZQbw1ZReZAO5HkokEtS8hiHp%2BNVnFPzZQLAiWXqHoO3hXkZTofjma618uhNfjFFYatgZX9Zio8XpSU9UaBL7sJiTqWY5cmDTKwbcc%2Ftck%3D'

    assert_equal string, @client.sdk_execute(
      method: 'alipay.trade.page.pay',
      biz_content: {
        out_trade_no: '20160401000000',
        product_code: 'QUICK_MSECURITY_PAY',
        total_amount: '0.01',
        subject: 'test'
      }.to_json(ascii_only: true),
      timestamp: '2016-04-01 00:00:00'
    )
  end

  def test_page_execute_url_for_alipay_trade_page_pay
    url = 'https://openapi.alipaydev.com/gateway.do?app_id=2016000000000000&charset=UTF-8&sign_type=RSA2&version=1.0&timestamp=2016-04-01+00%3A00%3A00&method=alipay.trade.page.pay&biz_content=%7B%22out_trade_no%22%3A%2220160401000000%22%2C%22product_code%22%3A%22FAST_INSTANT_TRADE_PAY%22%2C%22total_amount%22%3A%220.01%22%2C%22subject%22%3A%22test%22%7D&sign=CXmicQH4t0AxsFGodhA3n824fKsJHH%2BAt2RsRvr1poYhhPpk4UUxd0Zrrv9ytNP28Ov1seNl0zZf%2FPfIYmg5ZquUHyFbYrXL3zDtJQntwRYBncZlKGkNDt0Bg0fMU2bJK3xr8TLW1FiJMb1sZ1a2PQaeeEG0PV0b7cf4KDsxIwQ%3D'

    assert_equal url, @client.page_execute_url(
      method: 'alipay.trade.page.pay',
      biz_content: {
        out_trade_no: '20160401000000',
        product_code: 'FAST_INSTANT_TRADE_PAY',
        total_amount: '0.01',
        subject: 'test'
      }.to_json(ascii_only: true),
      timestamp: '2016-04-01 00:00:00'
    )
  end

  def test_page_execute_form_for_alipay_trade_page_pay
    form = "<form id='alipaysubmit' name='alipaysubmit' action='https://openapi.alipaydev.com/gateway.do' method='POST'><input type='hidden' name='app_id' value='2016000000000000'/><input type='hidden' name='charset' value='UTF-8'/><input type='hidden' name='sign_type' value='RSA2'/><input type='hidden' name='version' value='1.0'/><input type='hidden' name='timestamp' value='2016-04-01 00:00:00'/><input type='hidden' name='method' value='alipay.trade.page.pay'/><input type='hidden' name='biz_content' value='{\"out_trade_no\":\"20160401000000\",\"product_code\":\"FAST_INSTANT_TRADE_PAY\",\"total_amount\":\"0.01\",\"subject\":\"test\"}'/><input type='hidden' name='sign' value='CXmicQH4t0AxsFGodhA3n824fKsJHH+At2RsRvr1poYhhPpk4UUxd0Zrrv9ytNP28Ov1seNl0zZf/PfIYmg5ZquUHyFbYrXL3zDtJQntwRYBncZlKGkNDt0Bg0fMU2bJK3xr8TLW1FiJMb1sZ1a2PQaeeEG0PV0b7cf4KDsxIwQ='/><input type='submit' value='ok' style='display:none'></form><script>document.forms['alipaysubmit'].submit();</script>"

    assert_equal form, @client.page_execute_form(
      method: 'alipay.trade.page.pay',
      biz_content: {
        out_trade_no: '20160401000000',
        product_code: 'FAST_INSTANT_TRADE_PAY',
        total_amount: '0.01',
        subject: 'test'
      }.to_json(ascii_only: true),
      timestamp: '2016-04-01 00:00:00'
    )
  end

  def test_execute_for_data_dataservice_bill_downloadurl_query
    body = <<-EOF
      {
        "sign":"ERITJKEIJKJHKKKKKKKHJEREEEEEEEEEEE",
        "alipay_data_dataservice_bill_downloadurl_query_response":{
          "code":"10000",
          "bill_download_url":"http://dwbillcenter.alipay.com/downloadBillFile.resource?bizType=X&userId=X&fileType=X&bizDates=X&downloadFileName=X&fileId=X",
          "msg":"Success"
        }
      }
    EOF
    stub_request(:post, "https://openapi.alipaydev.com/gateway.do").
      to_return(body: body)

    assert_equal body, @client.execute(
      method: 'alipay.data.dataservice.bill.downloadurl.query',
      biz_content: {
        bill_type: 'trade',
        bill_date: '2016-04-01'
      }.to_json(ascii_only: true)
    )
  end

  # Use pair rsa key so we can test it
  def test_verify
    params = {
      out_trade_no: '20160401000000',
      trade_status: 'TRADE_SUCCESS'
    }
    params[:sign] = @client.sign(params)
    params[:sign_type] = 'RSA2'
    assert @client.verify?(params)
  end

  def test_verify_when_wrong
    params = {
      out_trade_no: '20160401000000',
      trade_status: 'TRADE_SUCCESS',
      sign_type: 'RSA2',
      sign: Base64.strict_encode64('WrongSign')
    }
    assert !@client.verify?(params)
  end
end
