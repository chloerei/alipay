require 'test_helper'

class Alipay::UtilsTest < Test::Unit::TestCase
  def test_stringify_keys
    hash = { 'a' => 1, :b => 2 }
    assert_equal({ 'a' => 1, 'b' => 2 }.sort, Alipay::Utils.stringify_keys(hash).sort)
  end
end
