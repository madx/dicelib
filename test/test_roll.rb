require File.join(File.dirname(__FILE__), 'helper')

class RollTests
  include Dicelib
  
  def setup
    @roll = Roll.new
  end
  
  def test_initialize
    [
      "--> Roll::new ",
      
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
          e.class.eql?(ArgumentError) && e.message.match?(/is not a dice$/)
        end
      }, true ],
      
      [ "Dice of a new roll should be unrolled", proc {
        roll = Roll.new(Dice.new, Dice.new, Dice.new, Dice.new)
        roll.dice.each_is?(:rolled?)
      }, false]
    ]
  end
  
  def test_add
    [
      "--> Roll#add",
      
      [ "@roll.add(Dice.new) should add a dice", proc {
        init_len = @roll.dice.length
        @roll.add(Dice.new)
        new_len  = @roll.dice.length
        [init_len == new_len - 1, @roll.dice.last.is_a?(Dice)]
      }, [true, true] ],
      
      [ "@roll.add(arg) should raise an error unless arg is a dice", proc {
        begin
          @roll.add('foo')
        rescue => e
          e.class.eql?(ArgumentError) && e.message.match?(/is not a dice$/)
        end
      }, true],
      
      [ "@roll << Dice.new should work just as add", proc {
        init_len = @roll.dice.length
        @roll << Dice.new
        new_len  = @roll.dice.length
        [init_len == new_len - 1, @roll.dice.last.is_a?(Dice)]
      }, [true, true] ],
      
      [ "@roll.add should return @roll", proc {
        @roll.add.is_a?(Roll) && @roll.add.object_id == @roll.object_id
      }, true ]
    ]
  end
  
  def test_expr
    [
      "--> Roll::expr",
      [ "Roll::expr should raise an error if argument is not a string", proc {
        begin
          Roll.expr(4)
        rescue => e
          e.class.eql?(ArgumentError) && e.message == "4 is not a string"
        end
      }, true ],
      
      [ "Roll::expr should raise an error if the provided string"+
        " doesn't match the format", proc {
        begin
          Roll.expr('abc')
          rescue => e
            e.class.eql?(ArgumentError) && e.message == "#{'abc'.inspect} doesn't match the format"
          end
      }, true ],
      
      [ "Roll.expr('4d6') should return 4 6-sided dice", proc {
        r = Roll.expr('4d6')
        r.dice.length.eql?(4) && r.dice.each_is?(Dice)
      }, true ]
    ]
  end
  
  def test_roll
    [
      "--> Roll#roll",
      
      [ "@roll.roll should raise an error when @roll.dice is empty", proc{
        begin
          @roll.roll
        rescue => e
          e.class.eql?(RollError) && e.message == "no dice to roll"
        end
      }, true ],
      
      [ "@roll.roll should return an array of values", proc {
        @roll.add(Dice.new, Dice.new)
        r = @roll.roll
        r.is_a?(Array) && r.each_is?(Fixnum)
      }, true ],
      
      [ "Dice of a rolled set should be rolled", proc {
        @roll.add(Dice.new, Dice.new)
        @roll.roll
        @roll.dice.each_is?(:rolled?)
      }, true ]
    ]
  end
  
  def test_rolled?
    [
      "--> Roll#rolled?",
      "    (true if *every* dice in the roll has been rolled)",
      
      [ "@roll.rolled? should be false if @roll has no dice", proc {
        @roll.rolled?
      }, false ],
      
      [ "@roll.rolled? should be false if no dice has been rolled", proc {
        @roll.add(Dice.new).rolled?
      }, false ],
      
      [ "@roll.rolled? should be false if there are unrolled dice", proc {
        @roll.add(Dice.new).roll
        @roll.add(Dice.new).rolled?
      }, false ],
      
      [ "@roll.rolled? should be true if every dice is rolled", proc {
        @roll.add(Dice.new, Dice.new).roll
        @roll.rolled?
      }, true ],
    ]
  end
  
end

run_tests(RollTests)
