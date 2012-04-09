#!/usr/bin/env ruby
# encoding: utf-8

# A library to help dealing with arabic text.
#
# This code is written by Cies Breijs.


module Arabic

  # The arabic alphabet as used in the Quran
  # The unicode characters used here are the general ones.
  # There are also contextual forms as seen here:
  # http://en.wikipedia.org/wiki/Arabic_(Unicode_block)
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

  # we only consider the original 28 arabic letters that where used when
  # the Quran was written down, added to that we allow: space, newline,
  # pipe and the western numbers
  VALID_CHARS = (ALPHABET.map{|k,v| k=v[0]} + ["|"," ","\n"] + (0..9).to_a.map(&:to_s)).freeze

  SPELLINGS_FOR = {
    ism: [
      [:alif, :sin, :mim],
      [:ba, :alif, :sin, :mim],
      [:alif, :lam, :alif, :sin, :mim] ],
    allah: [
      [:alif, :lam, :lam, :ha],
      [:waw, :alif, :lam, :lam, :ha],
      [:ba, :alif, :lam, :lam, :ha],
      [:fa, :lam, :lam, :ha],
      [:fa, :alif, :lam, :lam, :ha],
      [:ta, :alif, :lam, :lam, :ha],
      [:waw, :lam, :lam, :ha],
      [:waw, :ta, :alif, :lam, :lam, :ha],
      [:alif, :ba, :alif, :lam, :lam, :ha],
      [:lam, :lam, :ha] ],
    rahman: [
      [:alif, :lam, :ra, :hha, :mim, :nun],
      [:ba, :alif, :lam, :ra, :hha, :mim, :nun],
      [:lam, :lam, :ra, :hha, :mim, :nun] ],
    rahim: [
      [:alif, :lam, :ra, :hha, :ya, :mim],
      [:ra, :hha, :ya, :mim],
      [:ra, :hha, :ya, :mim, :alif] ],
    yewm: [
      [:ya, :waw, :mim],
      [:waw, :ba, :alif, :lam, :ya, :waw, :mim],
      [:ya, :waw, :mim, :alif],
      [:alif, :lam, :ya, :waw, :mim],
      [:waw, :ya, :waw, :mim],
      [:waw, :alif, :lam, :ya, :waw, :mim],
      [:lam, :ya, :waw, :mim],
      [:ya, :waw, :mim, :ya, :dhal],
      [:ba, :alif, :lam, :ya, :waw, :mim],
      [:ya, :waw, :mim, :kaf, :mim],
      [:ya, :waw, :mim, :ha, :mim],

      # [ :ya, :waw, :mim, :ya, :nun ]  -- days (plurial)

      ],
  }

end


class String
  def arabic_to_latin
    new_str = self.dup
    Arabic::ARABIC_TO_LATIN.each_pair { |k, v| new_str.gsub!(/#{k}/m, v) }
    new_str
  end
  alias :to_l :arabic_to_latin

  def arabic_to_gm_array
    new_str = self.dup.gsub(' ','').split('')  # make into array of letters (no spaces)
    h = {}
    Arabic::ALPHABET.values.each {|v| h[v[0]] = v[2]}
    new_str.map {|x| h[x]}
  end
  alias :to_gm :arabic_to_gm_array

  def arabic_to_sym_array
    new_str = self.dup.gsub(' ','').split('')  # make into array of letters (no spaces)
    h = {}
    Arabic::ALPHABET.each {|k,v| h[v[0]] = k}
    new_str.map {|x| h[x]}
  end
  alias :to_syms :arabic_to_sym_array

  def to_hex_a
    unpack("U*").map{|e| e = e.to_s(16)}
  end
end

class Array
  def symbols_to_arabic
    self.map{ |sym| Arabic::ALPHABET[sym][0] }.join
  end

  def sum
    self.reduce{|x,y| x+y}
  end
end
