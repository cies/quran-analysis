#!/usr/bin/env ruby
# encoding: utf-8

# A class for handling the Quran
#
# This code is written by Cies Breijs.


require "./arabic.rb"

class Quran
  BISMALLAH = "بسم الله الرحمن الرحيم"

  DEFAULT_QURAN_FILE = 'yuksel-transformed.txt'

  attr_accessor :file_name
  attr_accessor :text
  attr_accessor :numbered_text  # text as one big string exluding 0-verses

  # Letter sequences and the chapters that they occure in front of.
  INITIALS_AND_chapterS = {
    [:alif, :lam, :mim] => [2, 3] + (29..31).to_a,
    [:alif, :lam, :mim, :sad] => [7],
    [:alif, :lam, :ra] => (10..15).to_a - [13],
    [:alif, :lam, :mim, :ra] => [13],
    [:kaf, :ha, :ya, :ayn, :sad] => [19],
    [:tah, :ha] => [20],
    [:tah, :sin, :mim] => [26, 28],
    [:tah, :sin] => [27],
    [:ya, :sin] => [36],
    [:sad] => [38],
    [:hha, :mim] => (40..46).to_a,  # FIXME: should 42 be counted double
    [:ayn, :sin, :qaf] => [42],
    [:qaf] => [50],
    [:nun] => [68]
  }

  # Fill up a hash (chapter_nr => chapter_txt) from the quran file as supplied.
  # The file has to be in the zekr.org project format.  each line conforms:
  #   <chapter_nr>|<verse_nr>|<verse_text>
  # i.e.:
  #   19|19|قَالَ إِنَّمَا أَنَا رَسُولُ رَبِّكِ لِأَهَبَ لَكِ غُلَامًا زَكِيًّا
  def initialize(file_name=DEFAULT_QURAN_FILE)
    puts "Cannot read '#{file_name}'. Exitting." and exit unless File.stat(file_name).readable?
    @file_name = file_name
    @quran = Hash[(1..114).to_a.map{|e| e = [e, {}]}]  # { 1=>{}, 2=>{}, ..., 114=>{} }
    @verses = {}  # { "1:0" => "...", "1:1" => "...", ... }
    @text = ''
    @numbered_text = ''
    open(file_name).each_line do |l|
      if l.scan('|').size == 2
        chapter_nr, verse_nr, txt = l.split('|')
        @quran[chapter_nr.to_i][verse_nr.to_i] = txt.strip
        @verses[chapter_nr+':'+verse_nr] = ' '+txt.strip+' '  # padded
        @text << "#{chapter_nr}|#{verse_nr}|#{txt.strip}\n"
        if verse_nr.to_i > 0
          # txt is padded with space for easy-word-boundry-by-space find
          @numbered_text << "#{chapter_nr}|#{verse_nr}| #{txt.strip} \n"
        end
      end
    end
  end

  def [](key)
    @quran[key]
  end

  def chapters
    @quran
  end

  def verses
    @verses
  end

  def verse(str)
    chapter_nr, verse_nr = str.split(':')
    @quran[chapter_nr.to_i][verse_nr.to_i]
  end

  def count_in_numbered_text_with(strings)
    count = 0
    strings = [strings] if strings.class == String
    strings.each do |str|
      count += @numbered_text.scan(/ #{str}(?= )/).size
    end
    count
  end

  def find_verses_with(strings)
    count = 0
    verse_nr_sum = 0
    result = []
    strings = [strings] if strings.class == String
    verses.each do |address, verse|
      next if address =~ /\:0$/  # skip zero verses
      sub_count = 0
      strings.each do |str|
        # match the space padded verse
        # the lookahead is to make sure a space follows,
        # without consuming it (in case the next word also matches)
        sub_count += verse.scan(/ #{str}(?= )/).size
      end
      if sub_count > 0
        count += sub_count
        verse_nr_sum += address.split(':').last.to_i
        result << [count, address, verse_nr_sum]
      end
    end
    result
  end

  # def each_chapter
  # end

  def inspect
    "#<Quran '#{@file_name}' (#{self.object_id})>"
  end
end
