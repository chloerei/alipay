require 'test_helper'

class AlipayTest < Test::Unit::TestCase
  def test_debug_mode_default
    assert Alipay.debug_mode?
  end
end
