#!/usr/bin/env ruby
# encoding: utf-8

# Written by Cies Breijs



unless ARGV[0]
  puts "Usage: #{__FILE__} <file name>"
  puts "  Where the file is a tanzil text style formatted Quran."
  puts "  Please refer to the transform-*.rb tools to prepare texts."
  puts "  When providing a '-' instead of a file name the default is used."
  exit
end

# load the Quran
require "./quran.rb"
q = ( ARGV[0] == '-' ? Quran.new : Quran.new(ARGV[0]) )

# prepend ARGV's elements (except nr 0) with our default RSpec arguments
require "rspec"
orig_argv = ARGV.dup
(%w(-c -f d) + orig_argv[1..-1]).inject(ARGV.clear, :<<)




describe Quran do

  it "has a number of suras that is a multiple of 19" do
    (q.suras.size % 19).should == 0
  end



end
