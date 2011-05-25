#!/usr/bin/env ruby
# encoding: utf-8

# A class for handling the Quran
#
# This code is written by Cies Breijs.


require "./arabic.rb"

class Quran
  DEFAULT_QURAN_FILE = 'yuksel-transformed.txt'

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
    [:hha, :mim] => (40..46).to_a - [42],
    [:hha, :mim, :ayn, :sin, :qaf] => [42],
    [:qaf] => [50],
    [:nun] => [68]
  }

  # Fill up a hash (sura_nr => sura_txt) from the quran file as supplied.
  # The file has to be in the zekr.org project format.  each line conforms:
  #   <sura_nr>|<aya_nr>|<aya_text>
  # i.e.:
  #   19|19|قَالَ إِنَّمَا أَنَا رَسُولُ رَبِّكِ لِأَهَبَ لَكِ غُلَامًا زَكِيًّا
  def initialize(file_name=DEFAULT_QURAN_FILE)
    @file_name = file_name
    @quran = Hash[(1..114).to_a.map{|e| e = [e, {}]}]  # { 1=>{}, 2=>{}, ..., 114=>{} }
    puts "Cannot read '#{file_name}'. Exitting." and exit unless File.stat(file_name).readable?
    open(file_name).each_line do |l|
      if l.count('|') == 2
        sura, aya, txt = l.split('|')
        @quran[sura.to_i][aya.to_i] = txt.chomp
      end
    end
  end

  def [](key)
    @quran[key]
  end

  def suras
    @quran.values
  end

  # def each_sura
  # end

  def inspect
    "#<Quran '#{@file_name}' (#{self.object_id})>"
  end
end
