require File.join(File.dirname(__FILE__), 'helper')

class RollTests
  include Dicelib
  
  def setup
    @roll = Roll.new
  end
  
  def test_initialize
    [
      [ "@roll should be a Roll object", proc {
        @roll.is_a?(Roll)
      }, true ],
      
      [ "@roll.dice should return an empty array of dice", proc {
        @roll.dice.is_a?(Array)
      }, true],
      
      [ "Roll.new(Dice.new) should return an array with only one dice", proc {
        Roll.new(Dice.new).dice.length
      }, 1 ],
      
      [ "Roll.new('string') should return an ArgumentError", proc {
        begin
          Roll.new('foo')
        rescue => e
          e.class.eql?(ArgumentError) && e.message.eql?("argument is not a dice")
        end
      }, true ],
      
      [ "Dice of a new roll should be unrolled", proc {
        roll = Roll.new(Dice.new, Dice.new, Dice.new, Dice.new)
        roll.dice.inject{|b,d| b = d.rolled?}
      }, false]
    ]
  end
  
  def test_add
    [
      [ "@roll.add(Dice.new) should add a dice", proc {
        init_len = @roll.dice.length
        @roll.add(Dice.new)
        new_len  = @roll.dice.length
        [init_len == new_len - 1, @roll.dice.last.is_a?(Dice)]
      }, [true, true] ],
      
      [ "@roll << Dice.new should work just as add", proc {
        init_len = @roll.dice.length
        @roll << Dice.new
        new_len  = @roll.dice.length
        [init_len == new_len - 1, @roll.dice.last.is_a?(Dice)]
      }, [true, true] ]
    ]
  end
  
  def test_expr
    [
      [ "Roll.expr('4d6') should return 4 6-sided dice", proc {
        r = Roll.expr('4d6')
        r.dice.length.eql?(4) && r.dice.inject{|b, d| b = d.is_a?(Dice)}
      }, true ]
    ]
  end
  
  def test_roll
    [
      [ "@roll"]
    ]
  end
  
end

run_tests(RollTests)
