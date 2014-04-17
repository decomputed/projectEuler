require 'euler/version'
require 'set'

class Numbers

  def self.sum_until(limit, steps)
    finalSet = Set.new

    steps.each{
      |step|
      finalSet.merge((step..(limit-1)).step(step))
    }

    return finalSet.to_a.reduce(:+)
  end

  def self.fibonacciByRounding(number)

    phi = ((1 + Math.sqrt(5))/2)

    if number > 2

      return (((phi**number)/Math.sqrt(5))).round()
    end

    if number == 1
      return 1
    end

    if number == 2
      return 1
    end
  end


end
