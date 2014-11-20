class Prime

  attr_accessor :last_prime

  def initialize
    @last_prime = 2
  end

  def is_prime(number)
    (2..number).map{ |p| number%p}.select{|rest| rest == 0}.size == 1
  end

  def next_prime

    loop do
      @last_prime += 1
      break if is_prime(@last_prime)
    end

    @last_prime
  end

  def reset
    @last_prime = 2
  end

  def self.get_factors_for(n)
    primito = Prime.new
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

    factors
  end
end