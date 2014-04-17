#noinspection RubyResolve
require_relative '../lib/euler'
require 'test/unit'

class Problem001 < Test::Unit::TestCase

  def test_problem_1
    assert_equal(23, Numbers.sum_until(10, [3, 5]))
    assert_equal(233168, Numbers.sum_until(1000, [3, 5]))
  end

  def test_problem_2
    assert_equal(1, Numbers.fibonacciByRounding(1))
    assert_equal(1, Numbers.fibonacciByRounding(2))
    assert_equal(2, Numbers.fibonacciByRounding(3))
    assert_equal(3, Numbers.fibonacciByRounding(4))
    assert_equal(5, Numbers.fibonacciByRounding(5))
    assert_equal(8, Numbers.fibonacciByRounding(6))
    assert_equal(13, Numbers.fibonacciByRounding(7))
    assert_equal(21, Numbers.fibonacciByRounding(8))
    assert_equal(34, Numbers.fibonacciByRounding(9))
    assert_equal(55, Numbers.fibonacciByRounding(10))
    assert_equal(89, Numbers.fibonacciByRounding(11))
    assert_equal(144, Numbers.fibonacciByRounding(12))
    assert_equal(233, Numbers.fibonacciByRounding(13))
    assert_equal(377, Numbers.fibonacciByRounding(14))
    assert_equal(610, Numbers.fibonacciByRounding(15))
    assert_equal(987, Numbers.fibonacciByRounding(16))
    assert_equal(1597, Numbers.fibonacciByRounding(17))
    assert_equal(2584, Numbers.fibonacciByRounding(18))
    assert_equal(4181, Numbers.fibonacciByRounding(19))
    assert_equal(6765, Numbers.fibonacciByRounding(20))

    x=1
    sum = 0

    while Numbers.fibonacciByRounding(x) <= 4000000
      if x%3 == 0
        sum = sum + Numbers.fibonacciByRounding(x)
      end
      x = x+1
    end

    assert_equal(sum, 4613732)
  end

end