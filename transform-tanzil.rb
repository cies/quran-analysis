#!/usr/bin/env ruby
# encoding: utf-8

unless ARGV[0]
  puts "Usage: #{__FILE__} <file name>"
  puts "  Where the file is in my case a download from tanzil.net:"
  puts "    * http://tanzil.net/download/"
  puts "    * Simple clean"
  puts "    * No 'Includes'"
  puts "    * Fie format: 'Text (with verse numbers)'"
  exit
end

# The file as retrieved as shown in the usage is mirrored on github:
#   http://github.com/cies/quran-analysis
# (a transformed version is not provided that that would violate its license)
#
# This script transforms the original file to look more like Yuksel's:
#   * ...
# We do keep the tanzil.net file format.


require "./quran.rb"
BISMALLAH = Quran::BISMALLAH

formatted = ''
open(ARGV[0]).each_line do |l|

  # all lines that have:
  #   1. a bismallah,
  #   2. are 1st lines of a chapter, and
  #   3. are not from the first chapter
  # these lines should split out a zero-bismallah verse like yuksel's
  pre_strip = ''
  if l.match(BISMALLAH) and l =~ /\|1\|/ and not l[0..1] == '1|'
    chapter = l[/^\d+/]
    formatted << "#{chapter}|0|#{BISMALLAH}\n"
    pre_strip = l.gsub(BISMALLAH,'')
  else
    pre_strip = l
  end

  # skip blanks or comments lines with license
  # therefor should not redistribute
  next if l[0] == '#' or l.length < 3

  formatted << pre_strip.split('|').map(&:strip).join('|') + "\n"

end

# Remove verse 128 and 129 from chapter 9
# The reasons for this are outlined Edip Yuksel's book 'Nineteen'
# in chapter A8 'Controversies over 9:128-129' on p.452
formatted.gsub!(/^9\|12[89]\|.*?\n/m,'')  # non-greedy, multiline

p formatted.class
p formatted.size

# TODO: the following characters are not part of Arabic::VALID_CHARS, but to occur:
# {"إ"=>5105, "أ"=>9118, "ى"=>2592, "ؤ"=>672, "ة"=>2344, "آ"=>1511, "ئ"=>1182, "ء"=>1576}  # occurences
# {"إ"=>0x625, "أ"=>0x623, "ى"=>0x649, "ؤ"=>0x624, "ة"=>0x629, "آ"=>0x622, "ئ"=>0x626, "ء"=>0x621}  # unicode point
# maybe the complex alifs ("ﺇ","ﺃ","ﺁ","ﻯ") should be converted to an simple alif
# and "ﺅ"=>:waw
# "ﺓ"=> is a ta-mabuta (see wikipedia), should chekc what to do with this
# "ﺉ"=> is an :alif or a :ya
# "ﺀ"=> is an :alif or should be omitted

formatted.gsub!("\u{625}", Arabic::ALPHABET[:alif][0])
formatted.gsub!("\u{623}", Arabic::ALPHABET[:alif][0])
formatted.gsub!("\u{622}", Arabic::ALPHABET[:alif][0])
formatted.gsub!("\u{629}", Arabic::ALPHABET[:ha][0])
formatted.gsub!("\u{649}", Arabic::ALPHABET[:ya][0])
formatted.gsub!("\u{626}", Arabic::ALPHABET[:ya][0])
formatted.gsub!("\u{624}", Arabic::ALPHABET[:waw][0])
formatted.gsub!("\u{621}", '')



puts formatted
