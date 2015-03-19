require 'test_helper'

class AlipayTest < Test::Unit::TestCase
  def test_debug_mode_default
    assert Alipay.debug_mode?
  end

  def test_sign_type_default
    assert_equal 'MD5', Alipay.sign_type
  end
end
