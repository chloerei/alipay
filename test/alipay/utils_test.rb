require 'test_helper'

class Alipay::UtilsTest < Minitest::Test
  def test_stringify_keys
    hash = { 'a' => 1, :b => 2 }
    assert_equal({ 'a' => 1, 'b' => 2 }.sort, Alipay::Utils.stringify_keys(hash).sort)
  end

  def test_generate_batch_no
    assert_equal(24, Alipay::Utils.generate_batch_no.size)
  end

  def test_get_cert_sn
    assert_equal('28d1147972121b91734da59aa10f3c16', Alipay::Utils.get_cert_sn(TEST_APP_CERT))
  end

  def test_get_root_cert_sn
    assert_equal('28d1147972121b91734da59aa10f3c16_28d1147972121b91734da59aa10f3c16', Alipay::Utils.get_root_cert_sn(TEST_ALIPAY_ROOT_CERT))
  end

end
