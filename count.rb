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
ALPHABET = {
  alif: 'ا',
  ba:   'ب',
  ta1:  'ت',
  ta2:  'ث',
  gim:  'ج',
  ha1:  'ح',
  ha2:  'خ',
  dal1: 'د',
  dal2: 'ذ',
  ra:   'ر',
  zay:  'ز',
  sin:  'س',
  shin: 'ش',
  sad:  'ص',
  dad:  'ض',
  ta3:  'ط',
  za:   'ظ',
  ayn:  'ع',
  gayn: 'غ',
  fa:   'ف',
  qaf:  'ق',
  kaf:  'ك',
  lam:  'ل',
  mim:  'م',
  nun:  'ن',
  ha3:  'ه',
  waw:  'و',
  ya:   'ي'
}


# Array of arab letters that occur infront of suras.
#  [:alif, :lam, :mim, :ra, :sad, :ha1, :ta3, :sin, :ha3, :ya, :ayn, :qaf, :nun, :kaf],


# Fill up a hash (sura_nr => sura_txt) from the quran file as supplied.
# The file has to be in the zekr.org project format.  each line conforms:
#   <sura_nr>|<aya_nr>|<aya_text>
# i.e.:
#   19|19|قَالَ إِنَّمَا أَنَا رَسُولُ رَبِّكِ لِأَهَبَ لَكِ غُلَامًا زَكِيًّا
quran = {}
open(ARGV[0]).each_line do |l|
  if l.count('|') == 2
    sura, aya, txt = l.split('|')
    sura = sura.to_i
    quran[sura] ? quran[sura] += txt : quran[sura] = txt
  end
end


# Letter sequences and the suras that they occure in front of.
LETTERS_AND_SURAS = {
  [:alif, :lam, :mim] => [2, 3] + (29..31).to_a,
  [:alif, :lam, :mim, :sad] => [7],
  [:alif, :lam, :ra] => (10..15).to_a - [13],
  [:alif, :lam, :mim, :ra] => [13],
  [:kaf, :ha3, :ya, :ayn, :sad] => [19],
  [:ta3, :ha3] => [20],
  [:ta3, :sin, :mim] => [26, 28],
  [:ta3, :sin] => [27],
  [:ya, :sin] => [36],
  [:sad] => [38],
  [:ha1, :mim] => (40..46).to_a - [42],
  [:ha1, :mim, :ayn, :sin, :qaf] => [42],
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
      letter_counts[letters][i] += quran[sura].scan(ALPHABET[letter]).size
    end
  end
end

# Calculate totals, and print them with mod19s to the stdout.
letter_counts.each_pair do |letters,counts|
  total = counts.inject(0) { |sum,i| sum += i }
  print "#{letters.to_s.ljust(30)} "
  print "#{ counts.to_s.ljust(30)} => "
  print "#{total} (mod19: #{total%19})\n"
end


allah_count = 0
quran.each_value do |sura_txt|
  allah_count += sura_txt.scan("اللَّه").size
end
puts "\n\n\nTotal occurences of the word 'Allah': #{allah_count} (mod19: #{allah_count%19})"
