#!/usr/bin/env ruby
# encoding: utf-8

unless ARGV[0]
  puts "Usage: #{__FILE__} <file name>"
  puts "  Where the file is in my case a download from tanzil.net:"
  puts "    * http://tanzil.net/download/"
  puts "    * Simple clean"
  puts "    * No 'Includes'"
  puts "    * Fie format: 'Text (with aya numbers)'"
  exit
end

# The file as retrieved as shown in the usage is mirrored on github:
#   http://github.com/cies/quran-analysis
# (a transformed version is not provided that that would violate its license)
#
# This script transforms the original file to look more like Yuksel's:
#   * ...
# We do keep the tanzil.net file format.


# BISMALLAH = open(ARGV[0]).lines.first.chomp.split('|').last.freeze
BISMALLAH = "بسم الله الرحمن الرحيم"

formatted = ''
open(ARGV[0]).each_line do |l|

  # all lines that have:
  #   1. a bismallah,
  #   2. are 1st lines of a sura, and
  #   3. are not from the first sura
  # these lines should split out a zero-bismallah aya like yuksel's
  pre_strip = ''
  if l.match(BISMALLAH) and l =~ /\|1\|/ and not l[0..1] == '1|'
    sura = l[/^\d+/]
    formatted << "#{sura}|0|#{BISMALLAH}\n"
    pre_strip = l.gsub(BISMALLAH,'')
  else
    pre_strip = l
  end

  # skip blanks or comments lines with license
  # therefor should not redistribute
  next if l[0] == '#' or l.length < 3

  formatted << pre_strip.split('|').map(&:strip).join('|') + "\n"

end

# Remove aya 128 and 129 from sura 9
# The reasons for this are outlined Edip Yuksel's book 'Nineteen'
# in chapter A8 'Controversies over 9:128-129' on p.452
formatted.gsub!(/^9\|12[89]\|.*?\n/m,'')  # non-greedy, multiline


puts formatted
