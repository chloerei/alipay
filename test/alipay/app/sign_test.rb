require 'test_helper'
require 'base64'

class Alipay::App::SignTest < Minitest::Test
  def setup
    @params = {
      biz_content: {:name=>'顺道'}.to_json,
      out_trade_no: 'MEM1234567',
      total_amount: '0.01'
    }

  end

  def test_params_to_sorted_string
    assert_equal 'a=2&b=1', Alipay::App::Sign.params_to_sorted_string(b: 1, a: 2)
  end

  def test_params_to_encoded_string
    assert_equal 'biz_content=%7B%22name%22%3A%22%E9%A1%BA%E9%81%93%22%7D&out_trade_no=MEM1234567&total_amount=0.01', Alipay::App::Sign.params_to_encoded_string(@params)
  end

  def test_verify_with_rsa2
    sign = 'c1R7jXEzg/gMzCEwqBcrYf1EliSQEVyC2JaCt9AUkRqpxIQGeRAjA18gid3/ubFQn0vWC8ajNB0veyy7g7wlbi/gM/6S3qZpkLP5n+vgLG5v84IHVIHeQIf7a/U3olW2fFg9IonEr8ohIMYZD5IB89j+supMvtyPHhWHVal2N9k='
    assert Alipay::App::Sign.verify?(@params.merge(sign: sign, sign_type: 'RSA2'),
      sign_type: :rsa2,
      key: TEST_RSA_PUBLIC_KEY
    )
  end

  def test_verify_with_rsa
    sign = 'l+vXVjKLNqtCMAHDgaLdWZaUkjyKEfp85K3GzRx7HJnxdxHhF4MHh2AJdnzLdnp653BnGtPs8SBC/25D2edZdho0+6q+d8RJw0ZiDmZAg7WRP5rq7nB1/SBaH6hLgp8HXL6Uqwo42Rik3I4Ecw9u7uK1spt/Ph4vzZJBq5QMc9I='
    assert Alipay::App::Sign.verify?(@params.merge(sign: sign, sign_type: 'RSA'),
      sign_type: :rsa,
      key: TEST_RSA_PUBLIC_KEY
    )
  end
end
