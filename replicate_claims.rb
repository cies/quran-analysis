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

  it "has all chapters except 9 start with the 'bismallah' (and check 1st verse nr)" do
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

  it "spells 'bastata' in 7:69 with the letter 'sad'" do
    q[7][69].scan([:ba, :sad, :tah, :ha].symbols_to_arabic).size == 1
  end

end

describe "The Quran and the number 19:" do

  specify "the number of chapters (#{q.chapters.size}) is a multiple of 19" do
    (q.chapters.size % 19).should == 0
  end

  specify "114 (19x6) 'bismallahs': 1:1, 30:27 and in every chapter except 1 & 9 on verse 0" do
    q[1][1].should == Quran::BISMALLAH
    q[27][30].should =~ /#{Quran::BISMALLAH}/
    ((2..8).to_a + (10..114).to_a).each do |chapter_nr|
      q[chapter_nr][0].should == Quran::BISMALLAH
    end
    q[1][0].should be_nil
    q[9][0].should be_nil
  end

  specify "the 'bismallah' sentence consists of 19 letters" do
    Quran::BISMALLAH.split.join.size.should == 19
  end

  specify "the chapter of the missing 'bismallah' and the chapter with the double one span over 19 chapters" do
    (9..27).to_a.size.should == 19
  end

  specify "the gematrical values of the letters forming the 'bismallah' together with their index numbers form patterns that add up to multiples of 19"
    # See Edip Yuksel, 2011, ch.14, p.169

  specify "all the verses, including unnumbered 'bismallah', add up to 6346 (=19x334=6+3+4+6)" do
    # there are more interesting properties fo the number 6346 in
    # relation to 19 an the Quran.  see Yuksel, 2011, p.283
    verse_count = 0
    (1..114).each do |chapter_nr|
      verse_count += q[chapter_nr].length
    end
    verse_count.should == (19*334)
  end


  describe "Words of the 'bismallah':" do

    specify "1st word 'ism' occures 19x1 times in the numbered text" do
      derivatives = Arabic::SPELLINGS_FOR[:ism].map { |w| w.symbols_to_arabic }
      q.count_in_numbered_text_with(derivatives).should == 19
    end

    specify "2nd word 'Allah' occures 19x142 times in the numbered text" do
      derivatives = Arabic::SPELLINGS_FOR[:allah].map{ |w| w.symbols_to_arabic }
      q.count_in_numbered_text_with(derivatives).should == (19*142)
    end

    specify "3nd word 'rahman' occures 19x3 times in the numbered text" do
      derivatives = Arabic::SPELLINGS_FOR[:rahman].map{ |w| w.symbols_to_arabic }
      q.count_in_numbered_text_with(derivatives).should == (19*3)
    end

    specify "4nd word 'rahim' occures 19x6 times in the numbered text" do
      derivatives = Arabic::SPELLINGS_FOR[:rahim].map{ |w| w.symbols_to_arabic }
      q.count_in_numbered_text_with(derivatives).should == (19*6)
    end

    specify "the multiplication factors of the word frequencies add up to 152 (19x8)" do
      (1 + 142 + 3 + 6).should == (19*8)
    end

  end

  describe "Counting initial letters in the chapters they prefix" do

    specify "'qaf' affixes chapter 42 and 50, and occures 19x3 times in each of those chapters" do
      [42, 50].each do |chapter_nr|
        q.count_letters_in_chapter(chapter_nr, :qaf).should == (19*3)
      end
    end

    specify "'sad' affixes chapters 7, 19 and 38, and occures 19x8 times in those chapters together" do
      total_count = 0
      [7, 19, 38].each do |chapter_nr|
        total_count += q.count_letters_in_chapter(chapter_nr, :sad)
      end
      total_count.should == (19*8)
    end

    specify "'hha' and 'mim' affix chapters 40 to 46, and occure a combined total of 19x113 times" do
      total_count = 0
      (40..46).to_a.each do |chapter_nr|
        total_count += q.count_letters_in_chapter(chapter_nr, [:hha, :mim])
      end
      total_count.should == (19*113)
    end

    specify "'ayn', 'sin' and 'qaf' affix chapter 42, and occure 19x11 times therein" do
      q.count_letters_in_chapter(42, [:ayn, :sin, :qaf]).should == (19*11)
    end

    specify "'kaf', 'ha', 'ya', 'ayn' and 'sad' affix chapter 19, and occure 19x42 times therein" do
      q.count_letters_in_chapter(19, [:kaf, :ha, :ya, :ayn, :sad]).should == (19*42)
    end

    specify "'nun' affixes chapter 68 (spelled out as NWN), and occures 19x7 times therein" do
      q.count_letters_in_chapter(68, :nun).should == (19*7)
    end

    specify "'ya' and 'sin' affix chapter 36, and occure 19x15 times therein" do
      q.count_letters_in_chapter(36, [:ya, :sin]).should == (19*15)
    end

    specify "there are 19x6 (114) verses that contain all 14 initial letters" do
      verse_count = 0
      q.verses.each_pair do |address, verse_txt|
        initial_occurance_count = 0
        Quran::ALL_INITIALS.each do |initial_letter|
          if verse_txt.scan(Arabic::ALPHABET[initial_letter][0]).size > 0
            initial_occurance_count += 1
          end
        end
        verse_count += 1 if initial_occurance_count == Quran::ALL_INITIALS.length
      end
      verse_count.should == (19*6)
    end



  end

  describe "The numbers used in the Quran..." do
    specify "...form a unique set of 19x2"
    specify "...occure a combined total of 19x16 times"
    specify "...all integers total to 19x8534"
    # there are more in Yukel, 2011, p.239 (chapter and verse nr sums, etc)
  end

end
