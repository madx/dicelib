require 'rubygems'
require 'mtest'
require File.join(File.dirname(__FILE__), '..', 'lib', 'dicelib')

def run_tests(klass)
  puts 
  results = {:pass => 0, :fail => 0, :err => 0}
  (t = klass.new).methods.sort.each do |meth|
    if meth =~ /^test_/
      t.setup if t.respond_to?(:setup)
      MTest(t.__send__(meth.to_sym)).each {|k,v| results[k] += v }
      puts
    end
  end
  print "  Pass : "+"#{results[:pass]}"._g
  print " | Fail : "+"#{results[:fail]}"._r
  print " | Errors: "+"#{results[:err]}"._p+"\n"
end
