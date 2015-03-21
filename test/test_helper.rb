require 'minitest/autorun'
require 'alipay'
require 'fakeweb'

Alipay.pid = '1000000000000000'
Alipay.key = '10000000000000000000000000000000'
Alipay.seller_email = 'admin@example.com'

module Minitest::Assertions
  def assert_not_nil(obj, msg = nil)
    assert (obj != nil), msg
  end
end
