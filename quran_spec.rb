#!/usr/bin/env ruby
# encoding: utf-8

# Written by Cies Breijs


require "rspec"
require "./quran.rb"

q = Quran.new('quran-yuksel-satinized-formatted.txt')

describe Quran do

  it "has a number of suras that is a multiple of 19" do
    (q.suras.size % 19).should == 0
  end



end
