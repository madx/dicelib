module Dicelib
  class Dice

    include Comparable

    attr_accessor :sides
    attr_reader   :value
    
    SIDES = [4, 6, 8, 10, 12, 20, 100]
    DEFAULT_DICE = 6
    
    def initialize(sides=DEFAULT_DICE)
      if SIDES.include?(sides)
        @sides = sides.to_i
      else
        raise ArgumentError, "invalid sides (#{sides})"
      end
      @value = nil
    end
    
    def roll
      @value = (1..@sides).to_a[rand(@sides)]
    end
    
    def rolled?
      not @value.nil?
    end
    
    def <=>(d2)
      if !rolled?
        raise RollError, "first dice is not rolled"
      elsif !d2.rolled?
        raise RollError, "second dice is not rolled"
      else
        if sides != d2.sides
          sides <=> d2.sides
        else
          value <=> d2.value
        end
      end
    end
    
    def compares_with?(d2)
      sides != d2.sides ? :sides : :value
    end
    
    # Class methods
    class << self
      
      def roll(sides=DEFAULT_DICE)
        (1..sides).to_a[rand(sides)]
      end
      
    end # of class methods
    
  end # of class Dice
  
end # of module Dicelib
