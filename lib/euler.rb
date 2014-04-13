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

end
