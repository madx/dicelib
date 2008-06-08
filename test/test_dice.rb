require File.join(File.dirname(__FILE__), 'helper')

class DiceTests
  include Dicelib
  
  def setup
    @d = Dice.new
  end
  
  def test_initialize
    [
      "--> Dice::initialize",
      
      [ "Dice.new should return 6-sided dice", proc {
        @d.sides
      }, 6 ],
      
      [ "Dice.new(4) should return 4-sided dice", proc {
        Dice.new(4).sides
      }, 4 ],
      
      [ "Dice.new(3) should raise error with 'invalid sides (3)'", proc {
        begin
          Dice.new(3)
          false
        rescue => x
          x.message.eql?("invalid sides (3)") ? true : false
        end
      }, true ],
    ]
  end
  
  def test_accessors
    [
      "--> Accessors",
      [ "Dice should have 'sides' accessor (rw)", proc {
        [Dice.method_defined?(:sides), Dice.method_defined?(:sides=)]
      }, [true, true] ],
      
      [ "Dice should have 'value' accessor (r)", proc {
        [Dice.method_defined?(:value), Dice.method_defined?(:value=)]
      }, [true, false] ]
      
    ]
  end
  
  def test_roll
    [
      "--> Dice#roll",
      "   (note that those tests might be weak because of random values)",
      
      [ "Dice#roll should return a value between 1 and @sides (here 6)", proc {
        (1..6).include? @d.roll
      }, true ],
      
      [ "... same for 4 sides", proc {
        @d.sides = 4
        (1..4).include?(@d.roll)
      }, true ],
      
      [ "... and 8 sides", proc {
        @d.sides = 8
        (1..8).include?(@d.roll)
      }, true ],
      
      [ "... 100 also", proc {
        @d.sides = 100
        (1..100).include?(@d.roll)
      }, true ]
    ]
  end
  
  def test_value
    [
      "--> Dice#value",
      [ "Dice#value should return nil after initialization", proc {
        @d.value.nil?
      }, true ],
      
      [ "Dice#value should be an Integer between 1 and @sides after roll", proc {
        @d.roll
        [@d.value.is_a?(Integer), (1..@d.sides).include?(@d.value)]
      }, [true, true] ]
    ]
  end
  
  def test_rolled?
    [
      "--> Dice#rolled?",
      [ "Should return false if dice is not rolled", proc {
        @d.rolled?
      }, false ],
      
      [ "Should return true if dice is rolled", proc {
        @d.roll
        @d.rolled?
      }, true ]
    ]
  end
  
  def test_comparison
    [
      "--> Comparison",
      [ "Raise a RollError if first dice is not rolled", proc {
        begin
          @d <=> Dice.new
        rescue => e
          e.class.eql?(RollError) && e.message.eql?("first dice is not rolled")
        end
      }, true ],
      
      [ "Raise a RollError if second dice is not rolled", proc {
        begin
          @d.roll
          @d <=> Dice.new
        rescue => e
          e.class.eql?(RollError) && e.message.eql?("second dice is not rolled")
        end
      }, true ],
      
      [ "Dices with different sides should be compared with their side number", proc {
        @d.compares_with?(Dice.new(4))
      }, :sides ],
      
      [ "Two rolled dices with same sides should be compared with their value", proc {
        @d.roll
        (d2 = Dice.new).roll
        @d.compares_with?(d2)
      }, :value ],
    ]
  end
  
  def test_roll_class_method
    [
      "--> Dice::roll",
      "    (used for on-the-fly dice-rolling)",
      
      [ "Dice::roll should return an Integer", proc {
        Dice.roll.class
      }, Fixnum ],
      
      [ "Dice::roll should roll within 1 to 6", proc {
        (1..6).include?(Dice.roll)
      }, true ],
      
      [ "Dice::roll(4) should roll a 4-sided dice", proc {
        (1..4).include?(Dice.roll(4))
      }, true ]

    ]
  end
  
end

run_tests(DiceTests)
