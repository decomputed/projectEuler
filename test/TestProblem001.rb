#noinspection RubyResolve
require_relative '../lib/euler'
require 'test/unit'

class Problem001 < Test::Unit::TestCase

  def test_simple
    assert_equal(23, Numbers.sum_until(10,[3,5]))
    assert_equal(233168, Numbers.sum_until(1000,[3,5]))
  end

end