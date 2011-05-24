#!/usr/bin/env ruby
# encoding: utf-8

require 'optparse'
require 'irb'
require 'irb/completion'

LIBS = ['./quran.rb', './arabic.rb']
LIBS.each { |l| require l }

# extend the Kernel module so we can access a loaded instance of Quran with 'q'
module Kernel
  def q; Console.get_quran; end
  module_function :q

  def reload!; LIBS.each { |l| load l }; Console.load_quran!; end
  module_function :reload!
end

# this class takes care of setting up an IRB session with a Quran instance as specified by command line options
class Console
  def self.start
    new.start
  end

  def self.get_quran
    @@q
  end

  def start
    options = {}

    OptionParser.new do |opt|
      opt.banner =  "Usage: ./console [quran file] [options]"
      opt.separator "Without options it will try to load '#{Quran::DEFAULT_QURAN_FILE}'"
      opt.separator ""
      opt.separator "Options can be one of the following:"
      # opt.on('-s', '--sandbox', 'Rollback database modifications on exit.') { |v| options[:sandbox] = v }
      opt.on('-d', '--debug',   'Enable ruby-debugging for the console.')   { |v| options[:debug] = v }
      opt.parse!(ARGV)
    end

    if options[:debug]
      begin
        require 'ruby-debug'
        puts "=> Debugger enabled"
      rescue Exception
        puts "You need ruby-debug to use the debugging mode. With gems, use 'gem install ruby-debug' or 'gem install ruby-debug19'"
        exit
      end
    end

    Console.load_quran!

    IRB.start
  end

  def self.load_quran!
    @@q = ARGV.first ? Quran.new(ARGV.first) : Quran.new
  end
end

Console.start if $0 == __FILE__
