#!/usr/bin/env ruby
# encoding: utf-8

# A library to help dealing with arabic text.
#
# This code is written by Cies Breijs.


module Arabic

  # All information on the arabic alphabet
  ALPHABET = {
    alif:  ["ا", "A", 1],
    ba:    ["ب", "B", 2],
    ta:    ["ت", "T", 400],
    tha:   ["ث", "T̠", 500],  # _ (under)
    gim:   ["ج", "Ǧ", 3],    # v (over)
    hha:   ["ح", "Ḥ", 8],    # . (under)
    kha:   ["خ", "Ḫ", 600],  # U (under)
    dal:   ["د", "D", 4],
    dhal:  ["ذ", "D̠", 700],
    ra:    ["ر", "R", 200],
    zay:   ["ز", "Z", 7],
    sin:   ["س", "S", 60],
    shin:  ["ش", "Š", 300],  # v (over)
    sad:   ["ص", "Ṣ", 90],   # . (under)
    dad:   ["ض", "Ḍ", 800],  # . (under)
    tah:   ["ط", "Ṭ", 9],    # . (under)
    zah:   ["ظ", "Ẓ", 900],  # . (under)
    ayn:   ["ع", "ʿ", 70],
    ghayn: ["غ", "G", 1000],
    fa:    ["ف", "F", 80],
    qaf:   ["ق", "Q", 100],
    kaf:   ["ك", "K", 10],
    lam:   ["ل", "L", 30],
    mim:   ["م", "M", 40],
    nun:   ["ن", "N", 60],
    ha:    ["ه", "H", 5],
    waw:   ["و", "W", 6],
    ya:    ["ي", "Y", 10],
  }

  ARABIC_TO_LATIN = (a2l={}; ALPHABET.each_pair{|k,v| a2l[v[0]]=v[1]}; a2l).freeze
end


class String
  def arabic_to_latin
    Arabic::ARABIC_TO_LATIN.each_pair { |k, v| self.gsub!(k, v) }
    self
  end
  alias :to_l :arabic_to_latin
end

