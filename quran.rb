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
  attr_accessor :numbered_text  # text as one big string exluding 0-ayas

  # Letter sequences and the suras that they occure in front of.
  INITIALS_AND_SURAS = {
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

  # Fill up a hash (sura_nr => sura_txt) from the quran file as supplied.
  # The file has to be in the zekr.org project format.  each line conforms:
  #   <sura_nr>|<aya_nr>|<aya_text>
  # i.e.:
  #   19|19|قَالَ إِنَّمَا أَنَا رَسُولُ رَبِّكِ لِأَهَبَ لَكِ غُلَامًا زَكِيًّا
  def initialize(file_name=DEFAULT_QURAN_FILE)
    puts "Cannot read '#{file_name}'. Exitting." and exit unless File.stat(file_name).readable?
    @file_name = file_name
    @quran = Hash[(1..114).to_a.map{|e| e = [e, {}]}]  # { 1=>{}, 2=>{}, ..., 114=>{} }
    @text = ''
    @numbered_text = ''
    open(file_name).each_line do |l|
      if l.scan('|').size == 2
        sura, aya, txt = l.split('|')
        @quran[sura.to_i][aya.to_i] = txt.strip
        @text << "#{sura}|#{aya}|#{txt.strip}\n"
        if aya.to_i > 0
          # txt is padded with space for easy-word-boundry-by-space find
          @numbered_text << "#{sura}|#{aya}| #{txt.strip} \n"
        end
      end
    end
  end

  def [](key)
    @quran[key]
  end

  def suras
    @quran
  end

  def aya(str)
    sura_nr, aya_nr = str.split(':')
    # p [sura_nr, aya_nr]
    @quran[sura_nr.to_i][aya_nr.to_i]
  end

  def count_in_numbered_text_with(strings)
    count = 0
    strings = [strings] if strings.class == String
    strings.each do |str|
      count += @numbered_text.scan(" #{str} ").size
      @numbered_text.scan(/$\s#{str}\s\n/m) { |l| p l }
    end
    count
  end

  def find_ayas_in_numbered_text_with(strings)
    result = []
    strings = [strings] if strings.class == String
    strings.each do |str|
      count += @numbered_text.scan(" #{str} ").size
      @numbered_text.scan(/$\s#{str}\s\n/m) { |l| p l }
    end
    result
  end

  # def each_sura
  # end

  def inspect
    "#<Quran '#{@file_name}' (#{self.object_id})>"
  end
end
