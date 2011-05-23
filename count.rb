#!/usr/bin/env ruby
# encoding: utf-8

# Code to verify the remarkable numeric properties of the Qur'an.
#
# This is merely a quick proof of concept.  It foresee it wil grow into something far more extensive and organized.
# For more information see the README file.
#
# This code is written by Cies Breijs.


require 'awesome_print'

# This so we no not have to deal with unicode in the rest of the code.
# Got it from: http://www.al-bab.com/arab/language/roman1.htm
ALPHABET = {
  alif: 'ا',
  ba:   'ب',
  ta:   'ت',
  tha:  'ث',
  jim:  'ج',
  ha:   'ح',
  hha:  'خ',
  dal:  'د',
  dhal: 'ذ',
  ra:   'ر',
  zay:  'ز',
  sin:  'س',
  shin: 'ش',
  sad:  'ص',
  dad:  'ض',
  tah:  'ط',
  zah:  'ظ',
  ayn:  'ع',
  ghayn:'غ',
  fa:   'ف',
  qaf:  'ق',
  kaf:  'ك',
  lam:  'ل',
  mim:  'م',
  nun:  'ن',
  ha:   'ه',
  waw:  'و',
  ya:   'ي'
}


# Array of arab letters that occur infront of suras.
#  [:alif, :lam, :mim, :ra, :sad, :ha, :tah, :sin, :ha, :ya, :ayn, :qaf, :nun, :kaf],


# Fill up a hash (sura_nr => sura_txt) from the quran file as supplied.
# The file has to be in the zekr.org project format.  each line conforms:
#   <sura_nr>|<aya_nr>|<aya_text>
# i.e.:
#   19|19|قَالَ إِنَّمَا أَنَا رَسُولُ رَبِّكِ لِأَهَبَ لَكِ غُلَامًا زَكِيًّا
@@quran = {}
open(ARGV[0]).each_line do |l|
  if l.count('|') == 2
    sura, aya, txt = l.split('|')
    sura = sura.to_i
    @@quran[sura] ? @@quran[sura] += txt : @@quran[sura] = txt
  end
end


# Letter sequences and the suras that they occure in front of.
LETTERS_AND_SURAS = {
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
  [:ha, :mim] => (40..46).to_a - [42],
  [:ha, :mim, :ayn, :sin, :qaf] => [42],
  [:qaf] => [50],
  [:nun] => [68]
}

# letter_counts data structure is initialized here.
letter_counts = LETTERS_AND_SURAS.dup
letter_counts.each_key { |k| letter_counts[k] = Array.new(k.length, 0) }

# Count the letters of sura-groups that share the same initials.
# Keeps individual letter counts in the letter_count data structure.
LETTERS_AND_SURAS.each_pair do |letters, suras|
  letters.each_with_index do |letter, i|
    suras.each do |sura|
      letter_counts[letters][i] += @@quran[sura].scan(ALPHABET[letter]).size
    end
  end
end

def with_mod19(number)
  "#{number} (mod19: #{number%19})"
end

# Calculate totals, and print them with mod19s to the stdout.
letter_counts.each_pair do |letters,counts|
  total = counts.inject(0) { |sum,i| sum += i }
  print "#{letters.to_s.ljust(30)} "
  print "#{ counts.to_s.ljust(30)} => "
  print "#{with_mod19(total)}\n"
end

puts "\n"

def count_string(str, latinization = nil)
  count = 0
  @@quran.each_value { |sura_txt| count += sura_txt.scan(str).size }
  puts "Total occurences #{("'" + (latinization || str) + "':").ljust(10)} #{with_mod19(count)}"
end

def count_letters_in_sura(sura_nr)
  sura_txt = @@quran[sura_nr]
  sura_txt.gsub!("بسم الله الرحمن الرحيم", '')
  total = 0
  istr = ''
  sura_txt[1..-1].gsub(/\s+/,' ').split(/\s+/).each_with_index do |word,i|
    puts "#{i} #{word}: #{word.length}"
    total += word.length
    istr << word.length.to_s
  end
  puts istr
  #sura_txt.gsub!(/\s+/, '')
  puts "The number of letters in sura #{sura_nr}: #{with_mod19(total)}"
end

count_string "بسم", "Bism"
count_string "الله", "Allah"
count_string "رحمن", "Rahman"
count_string "رحيم", "Rahim"
count_string "ا", "Alif"

count_letters_in_sura 96
