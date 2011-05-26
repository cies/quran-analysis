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


require "./arabic.rb"

# load the Quran
require "./quran.rb"
q = ( ARGV[0] == '-' ? Quran.new : Quran.new(ARGV[0]) )

# prepend ARGV's elements (except nr 0) with our default RSpec arguments
require "rspec"
orig_argv = ARGV.dup
(%w(-c -f d) + orig_argv[1..-1]).inject(ARGV.clear, :<<)


puts "== Replication of claims of intriguing numeric properties of the Quran"
puts "=> loaded '#{q.file_name}'"


# first some generic tests
describe "The text we are considering:" do

  it "has all sura except 9 start with the 'bismallah' (and check 1st aya nr)" do
    q.suras.each_pair do |sura_nr, sura|
      first_aya_nr = sura.keys.sort.first
      first_aya = sura[first_aya_nr]
      case sura_nr
      when 1
        # TODO: find out if this is on purpose
        first_aya_nr.should == 1
        first_aya.should == Quran::BISMALLAH
      when 9
        first_aya_nr.should == 1
        first_aya.should_not =~ /#{Quran::BISMALLAH}/
      else
        first_aya_nr.should == 0
        first_aya.should == Quran::BISMALLAH
      end
    end
  end

  it "does not contain the disputed 9:128-129" do
    q[9][128].should be_nil
    q[9][129].should be_nil
  end
end

describe "Number 19 related claims:" do

  it "has  number of suras (#{q.suras.size}) that is a multiple of 19" do
    (q.suras.size % 19).should == 0
  end

  it "has 114 (19x6) 'bismallahs': 1:1, 30:27 and in every sura except 1 & 9 on aya 0" do
    q[1][1].should == Quran::BISMALLAH
    q[27][30].should =~ /#{Quran::BISMALLAH}/
    ((2..8).to_a + (10..114).to_a).each do |sura_nr|
      q[sura_nr][0].should == Quran::BISMALLAH
    end
    q[1][0].should be_nil
    q[9][0].should be_nil
  end

  it "'bismallah' sentence consists of 19 letters" do
    Quran::BISMALLAH.split.join.size.should == 19
  end

  it "the sura of the missing 'bismallah' and the sura with the double one span over 19 suras" do
    (9..27).to_a.size.should == 19
  end

  it "1st word of 'bismallah', SM, occures 19 times in the numbered text" do
    q.count_in_numbered_text_with(['اسم', 'بسم', 'الاسم']).should == 19  # ASM, BASM, ALASM
  end
end
