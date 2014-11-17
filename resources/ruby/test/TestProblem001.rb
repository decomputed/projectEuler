#noinspection RubyResolve
require_relative '../lib/euler'
require_relative '../lib/prime'
require 'test/unit'

class Problem001 < Test::Unit::TestCase

  def test_problem_1
    assert_equal(23, Numbers.sum_until(10, [3, 5]))
    assert_equal(233168, Numbers.sum_until(1000, [3, 5]))
  end

  def test_problem_2
    assert_equal(1, Numbers.fibonacci_by_rounding(1))
    assert_equal(1, Numbers.fibonacci_by_rounding(2))
    assert_equal(2, Numbers.fibonacci_by_rounding(3))
    assert_equal(3, Numbers.fibonacci_by_rounding(4))
    assert_equal(5, Numbers.fibonacci_by_rounding(5))
    assert_equal(8, Numbers.fibonacci_by_rounding(6))
    assert_equal(13, Numbers.fibonacci_by_rounding(7))
    assert_equal(21, Numbers.fibonacci_by_rounding(8))
    assert_equal(34, Numbers.fibonacci_by_rounding(9))
    assert_equal(55, Numbers.fibonacci_by_rounding(10))
    assert_equal(89, Numbers.fibonacci_by_rounding(11))
    assert_equal(144, Numbers.fibonacci_by_rounding(12))
    assert_equal(233, Numbers.fibonacci_by_rounding(13))
    assert_equal(377, Numbers.fibonacci_by_rounding(14))
    assert_equal(610, Numbers.fibonacci_by_rounding(15))
    assert_equal(987, Numbers.fibonacci_by_rounding(16))
    assert_equal(1597, Numbers.fibonacci_by_rounding(17))
    assert_equal(2584, Numbers.fibonacci_by_rounding(18))
    assert_equal(4181, Numbers.fibonacci_by_rounding(19))
    assert_equal(6765, Numbers.fibonacci_by_rounding(20))

    x=1
    sum = 0

    while Numbers.fibonacci_by_rounding(x) <= 4000000
      if x%3 == 0
        sum = sum + Numbers.fibonacci_by_rounding(x)
      end
      x = x+1
    end

    assert_equal(sum, 4613732)
  end

  def test_problem_3

    primito = Prime.new

    assert_equal(primito.last_prime, 2)

    primito.next_prime
    primito.next_prime

    assert_equal(primito.last_prime, 5)

    primito.reset

    assert_equal(primito.last_prime, 2)

    # first test
    n = 13195
    factors = []

    loop do
      break if n == 1
      if n % primito.last_prime == 0

        n /= primito.last_prime
        factors.push(primito.last_prime)
      else
        primito.next_prime
      end
    end

    assert_equal(29, factors.last())

    # actual calculation
    n = 600851475143
    factors = []

    loop do
      break if n == 1
      if n % primito.last_prime == 0

        n /= primito.last_prime
        factors.push(primito.last_prime)
      else
        primito.next_prime
      end
    end

    assert_equal(6857, factors.last())

  end

end