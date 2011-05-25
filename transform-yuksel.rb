#!/usr/bin/env ruby

unless ARGV[0]
  puts "Usage: #{__FILE__} <file name>"
  puts "  Where the file is in my case a unicode TXT export (by OpenOffice)"
  puts "  from the original DOC file obtained from Edip Yuksel."
  exit
end

# a line of yukel's original is formatted like:
#    (19:19) قال انما انا رسول ربك لاهب لك غلما زكيا
# it can contain extra white space and blank lines
# we transform it to the tanzil format (for use with most tools):
#    19|19|ﻕﺎﻟ ﺎﻨﻣﺍ ﺎﻧﺍ ﺮﺳﻮﻟ ﺮﺒﻛ ﻼﻬﺑ ﻞﻛ ﻎﻠﻣﺍ ﺰﻜﻳﺍ

formatted = ''
open(ARGV[0]).each_line do |l|
  next if l.strip.length < 3  # too short must be a blank line
  formatted << l.gsub(/^\s*\(\s*/,'').gsub(/:/,'|').gsub(/\s*\)\s*/,'|').strip
  formatted << "\n"
end
puts formatted
