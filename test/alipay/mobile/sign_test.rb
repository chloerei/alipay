require 'test_helper'

class Alipay::Mobile::SignTest < Minitest::Test
  def test_params_to_string
    assert_equal %q(a="1"&b="2"), Alipay::Mobile::Sign.params_to_string(a: 1, b: 2)
  end
end
