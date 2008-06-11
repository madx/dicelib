module Dicelib

  class Roll
  
    attr_reader :dice
  
    def initialize(*dice)
      @dice = []
      dice.each do |d|
        raise ArgumentError, "#{d.inspect} is not a dice" unless d.is_a?(Dice)
        @dice << d
      end
    end
    
    def self.expr(str)
      raise ArgumentError, "#{str} is not a string" unless str.is_a?(String)
      if str.match(/(\d+)d(\d+)/)
        dice = []
        $~[1].to_i.times { dice << Dice.new($~)}
      else
        raise ArgumentError, "#{str.inspect} doesn't match the format"
      end
    end
    
    def add(*dice)
      dice.each do |d|
        raise ArgumentError, "#{d.inspect} is not a dice" unless d.is_a?(Dice)
        @dice << d
      end
      self
    end
    alias_method :<<, :add
    
    def roll
      if @dice.empty?
        raise RollError, "no dice to roll"
      else
        @dice.each{ |d| d.roll }
      end
      @dice.collect{|d| d.value }
    end
    
    def rolled?
      return false if @dice.empty?
      answer = true
      for d in @dice
        unless d.rolled?
          answer = false
          break
        end
      end
      answer
    end
  
  end

end
