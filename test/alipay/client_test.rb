require 'test_helper'

class Alipay::ClientTest < Minitest::Test
  def setup
    @client = Alipay::Client.new(
      url: 'https://openapi.alipaydev.com/gateway.do',
      app_id: '2016000000000000',
      app_private_key: TEST_RSA_PRIVATE_KEY,
      format: 'json',
      charset: 'utf-8',
      alipay_public_key: TEST_RSA_PUBLIC_KEY,
      sign_type: 'RSA2'
    )
  end

  def test_client_initialize
    refute_nil @client
  end

  def test_request_url_for_alipay_trade_page_pay
    assert_equal 'https://openapi.alipaydev.com/gateway.do?app_id=2016000000000000&charset=utf-8&sign_type=RSA2&version=1.0&timestamp=2016-04-01+00%3A00%3A00&method=alipay.trade.page.pay&biz_content=%7B%22out_trade_no%22%3A%2220160401000000%22%2C%22product_code%22%3A%22FAST_INSTANT_TRADE_PAY%22%2C%22total_amount%22%3A%220.01%22%2C%22subject%22%3A%22test%22%7D&sign=Dyx7%2BjfeGF4qgBHjJt6i2mJ9brI6uamBeq%2BH6SLe44CjtphTpBq5HUeuvGI7Dhar%2FzgfMP0tzBCwEjb%2FKdwG3ZdcyB6jOWzwi5YX3fVjLx%2FsFY5qr%2Fng%2BCuEsuZ5QId%2FLGQnp04cT%2BefayR20qfMwmAjQVowBBy3KsKb7iYdn6k%3D', @client.request_url(method: 'alipay.trade.page.pay', biz_content: { out_trade_no: '20160401000000', product_code: 'FAST_INSTANT_TRADE_PAY', total_amount: '0.01', subject: 'test' }.to_json, timestamp: '2016-04-01 00:00:00')
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
    assert_equal body, @client.execute(method: 'data.dataservice.bill.downloadurl.query', biz_content: { bill_type: 'trade', bill_date: '2016-04-01' })
  end
end
