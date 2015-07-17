require 'test_helper'

class Alipay::Sign::RSATest < Minitest::Test
  def setup
    @string = "partner=123&service=test"
    @sign = "TaVXdP/0ia5NxIv9T76v6vGOrtgoaFrwnchKIWP9PQeX1UkUVxaq6ejDFmXF\nrFR+Plk+E/XzfV2DYJSVt0Am0qJRSgeg+PuvK+yWGCGm9GJgUJlS4Eyta3g+\n8DWwRWTjUyh5yzlf9JoSnbNjYpBolnMRD7B/u1JLkTMJuMx2TVM=\n"
  end

  def test_sign
    assert_equal @sign.gsub("\n", ''), Alipay::Sign::RSA.sign(TEST_RSA_PRIVATE_KEY, @string)
  end

  def test_verify
    assert Alipay::Sign::RSA.verify?(TEST_RSA_PUBLIC_KEY, @string, @sign)
  end

  def test_verify_fail_when_sign_not_true
    assert !Alipay::Sign::RSA.verify?(TEST_RSA_PUBLIC_KEY, "danger#{@string}", @sign)
  end
end
