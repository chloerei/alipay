require 'minitest/autorun'
require 'alipay'
require 'fakeweb'

Alipay.pid = 'pid'
Alipay.key = 'key'
Alipay.seller_email = 'chloerei@gmail.com'
Alipay.debug_mode = true

module Minitest::Assertions
  def assert_not_nil(obj, msg = nil)
    assert (obj != nil), msg
  end
end
