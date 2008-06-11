module Dicelib

  class Roll
  
    attr_reader :dice
  
    def initialize(*dice)
      @dice = []
      dice.each do |d|
        raise ArgumentError, "argument is not a dice" unless d.is_a?(Dice)
        @dice << d
      end
    end
  
  end

end
