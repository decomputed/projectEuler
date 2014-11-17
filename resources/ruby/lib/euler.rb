require 'euler/version'
require 'set'

class Numbers

  def self.sum_until(limit, steps)
    final_set = Set.new

    steps.each{
      |step|
      final_set.merge((step..(limit-1)).step(step))
    }

    return final_set.to_a.reduce(:+)
  end

  def self.fibonacci_by_rounding(number)

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
