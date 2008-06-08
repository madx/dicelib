module Dicelib
  
  class RollError < RuntimeError; end
  
end

require File.join(File.dirname(__FILE__), 'dicelib', 'dice')
