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

  it "has all chapter except 9 start with the 'bismallah' (and check 1st verse nr)" do
    q.chapters.each_pair do |chapter_nr, chapter|
      first_verse_nr = chapter.keys.sort.first
      first_verse = chapter[first_verse_nr]
      case chapter_nr
      when 1
        # TODO: find out if this is on purpose
        first_verse_nr.should == 1
        first_verse.should == Quran::BISMALLAH
      when 9
        first_verse_nr.should == 1
        first_verse.should_not =~ /#{Quran::BISMALLAH}/
      else
        first_verse_nr.should == 0
        first_verse.should == Quran::BISMALLAH
      end
    end
  end

  it "does not contain the disputed 9:128-129" do
    q[9][128].should be_nil
    q[9][129].should be_nil
  end
end

describe "Number 19 related claims:" do

  it "has  number of chapters (#{q.chapters.size}) that is a multiple of 19" do
    (q.chapters.size % 19).should == 0
  end

  it "has 114 (19x6) 'bismallahs': 1:1, 30:27 and in every chapter except 1 & 9 on verse 0" do
    q[1][1].should == Quran::BISMALLAH
    q[27][30].should =~ /#{Quran::BISMALLAH}/
    ((2..8).to_a + (10..114).to_a).each do |chapter_nr|
      q[chapter_nr][0].should == Quran::BISMALLAH
    end
    q[1][0].should be_nil
    q[9][0].should be_nil
  end

  it "'bismallah' sentence consists of 19 letters" do
    Quran::BISMALLAH.split.join.size.should == 19
  end

  it "the chapter of the missing 'bismallah' and the chapter with the double one span over 19 chapters" do
    (9..27).to_a.size.should == 19
  end

  describe "Words of the 'bismallah':" do

    specify "1st word 'ism' occures 19 times in the numbered text" do
      derivatives = Arabic::SPELLINGS_FOR[:ism].map { |w| w = w.map{|l| l = Arabic::ALPHABET[l][0]}.join }
      q.count_in_numbered_text_with(derivatives).should == 19
    end

    specify "2nd word 'Allah' occures 19x142 times in the numbered text" do
      derivatives = Arabic::SPELLINGS_FOR[:allah].map{ |w| w = w.map{|l| l = Arabic::ALPHABET[l][0]}.join }
      q.count_in_numbered_text_with(derivatives).should == (19*142)
    end

    specify "3nd word 'rahman' occures 19x3 times in the numbered text" do
      derivatives = Arabic::SPELLINGS_FOR[:rahman].map{ |w| w = w.map{|l| l = Arabic::ALPHABET[l][0]}.join }
      q.count_in_numbered_text_with(derivatives).should == (19*3)
    end

    specify "4nd word 'rahim' occures 19x6 times in the numbered text" do
      derivatives = Arabic::SPELLINGS_FOR[:rahim].map{ |w| w = w.map{|l| l = Arabic::ALPHABET[l][0]}.join }
      q.count_in_numbered_text_with(derivatives).should == (19*6)
    end


  end

end
