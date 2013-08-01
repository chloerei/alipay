require 'test_helper'

class Alipay::UtilsTest < Test::Unit::TestCase
  def test_symbolize_keys
    hash = { 'a' => 1, :b => 2 }
    assert_equal({ :a => 1, :b => 2 }.sort, Alipay::Utils.symbolize_keys(hash).sort)
  end
end
