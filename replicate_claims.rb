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
# q = ( ARGV[0] == '-' ? Quran.new : Quran.new(ARGV[0]) )
q = Quran.new

# prepend ARGV's elements (except nr 0) with our default RSpec arguments
require "rspec"
orig_argv = ARGV.dup
(%w(-c -f d) + orig_argv[1..-1]).inject(ARGV.clear, :<<)


$stderr.puts
$stderr.puts "== Replicating claims of intriguing numeric properties of the Quran"
$stderr.puts "=> loaded '#{q.file_name}'"


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


describe "Remarkable word counts" do

  specify "the word day, 'yewm' (and derivatives), occurs a total of 365 times" do
    derivatives = Arabic::SPELLINGS_FOR[:yewm].map{ |w| w.symbols_to_arabic }
    q.count_in_numbered_text_with(derivatives)
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

  specify "the first chapter revealed, chapter 96, consists of 19 verses and is the 19th verse from the back" do
    (q[96].size - 1).should == 19  # compensate for the bismallah
    (96..114).to_a.size.should == 19
  end

  specify "the first chapter revealed consists of 304 (19x16) arabic letters" do
    q[96].values.join(' ').split(' ').join('').length.should == (19*16)
  end

  specify "the first revelation, 96:1-5, consists of 19 words" do
    (1..5).map{|x| q[96][x]}.join(' ').split(' ').size.should == 19
    # last 2 words here sow up as one word on some website... anybody some input on this one?
  end

  specify "the first revelation, 96:1-5, consists of 76 (19x4) letters" do
    (1..5).map{|x| q[96][x]}.join.gsub(' ','').length.should == (19*4)
  end

  specify "the last chapter revealed, chapter 110, has 19 words" do
    verse_strings = q[110].values[1..-1]  # remove the bismallah whos words do not count as a verse
    verse_strings.join(' ').split(' ').size.should == 19
  end

  specify "the first verse of the last chapter revealed, chapter 110, consists of 19 letters" do
    q[110][1].gsub(' ','').size.should == 19
  end

  specify "the 'bismallah' sentence consists of 19 letters" do
    Quran::BISMALLAH.split.join.size.should == 19
  end

  specify "the chapter of the missing 'bismallah' and the chapter with the double one span over 19 chapters, and the numbers of those chapters add up to 342 (19x18)" do
    (9..27).to_a.size.should == 19
    (9..27).to_a.sum.should == (19*18)
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

  specify "the letters of the arabic word for 'one', 'wahd' (واحد), has a geometrical sum of 19" do
    "واحد".to_gm.sum.should == 19
  end

  specify "the arabic word 'one', 'wahd' (ﻭﺎﺣﺩ), is used 19 times in reference to God"

  specify "the sum of the chapter and verse numbers of the verse where the word 'one' appears for the 19th time is 361 (19x19)"

  # specify "the sum of the chapter and verse numbers of verses that consist of 19 letters is (572x19)" do
  #   # i made this one myself, maybe it is worth checking all verses for potential errors that would lead to this
  #   c = 0
  #   q.verses.each_pair{|k,v| c += k.split(":").map(&:to_i).sum if v.length == 19  }
  #   c.should == 572*19
  # end

  specify "the 30 different natural numbers mentioned in the Quran (without repetitions) total to 162146 (19x8534)" do
    # the following chart is all over the internet, ofcoure I'd rather string search
    # through the text; but i'm afraid it will be hard to prove that no other numbers
    # besides these are mentioned (search for all that looks like number-word)
    # note: all numbers in the Quran are written out
    %w{1 7  19 70  1000
       2 8  20 80  2000
       3 9  30 99  3000
       4 10 40 100 5000
       5 11 50 200 50000
       6 12 60 300 100000}.map(&:to_i).sum.should == (19*8534)
  end

  specify "besides the thirty natural numbers, eight fractions are mentions, totalling 38 (19x2)" do
    # see the previous comment
    # the fractions are: 1/10, 1/8, 1/6, 1/5, 1/4, 1/3, 1/2 and 2/3
    ((30+8) % 19).should == 0
  end

  specify "the first chapter from the beginning with 19 verses is 82. this chapter ends with the word 'Allah', which is the 19th appearance of this word in the numbered text counted from the end." do
    first_19 = 0
    q.chapters.keys.sort.each {|x| first_19 = x and break if q[x].size - 1 == 19}
    first_19.should == 82

    allah_spellings = Arabic::SPELLINGS_FOR[:allah].map{ |w| w.symbols_to_arabic }
    allah_spellings.include?(q[82][19].split(' ').last).should == true

    count = 0
    allah_spellings.each do |str|
      count += (83..114).map{|x| q[x].values.join(' ')}.join(' ').scan(/ #{str}(?= )/).size
    end
    actual_count = count - (83..114).to_a.size  # compensate for 'Allah' in the bismallahs
    (actual_count + 1).should == 19  # add one as we did not yet count the last word 'Allah' of chapter 82 itself
  end

  # describe "The numbers used in the Quran..." do
  #   specify "...form a unique set of 19x2"
  #   specify "...occure a combined total of 19x16 times"
  #   specify "...all integers total to 19x8534"
  #   # there are more in Yukel, 2011, p.239 (chapter and verse nr sums, etc)
  # end


  describe "Words of the 'bismallah':" do

    specify "1st word 'ism' occures 19x1 times in the numbered text" do
      derivatives = Arabic::SPELLINGS_FOR[:ism].map { |w| w.symbols_to_arabic }
      q.count_in_numbered_text_with(derivatives).should == (19*1)
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

end
