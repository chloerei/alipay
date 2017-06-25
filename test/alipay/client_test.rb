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
end
