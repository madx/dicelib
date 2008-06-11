module Dicelib
  
  class RollError < RuntimeError; end
  
end

%w(dice roll).each do |lib|
  require File.join(File.dirname(__FILE__), 'dicelib', lib)
end
