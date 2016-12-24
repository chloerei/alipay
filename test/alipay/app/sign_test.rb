require 'test_helper'

class Alipay::App::SignTest < Minitest::Test
  def test_params_to_sorted_string
    assert_equal %q(a=2&b=1), Alipay::App::Sign.params_to_sorted_string(b: 1, a: 2)
  end

  def test_params_to_encoded_string
    assert_equal %q(biz_content=%7B%3Aname%3D%3E%22%E9%A1%BA%E9%81%93%22%7D&out_trade_no=MEM1234567&total_amount=0.01), Alipay::App::Sign.params_to_encoded_string(
      biz_content: {:name=>'顺道'},
      out_trade_no: 'MEM1234567',
      total_amount: '0.01'
    )
  end
end
