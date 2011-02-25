#!/usr/bin/env ruby
require 'rubygems'
require 'linguistics'
Linguistics::use( :en )

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'idea_machine')

files = Dir[File.join(File.dirname(__FILE__), 'parts', '*.txt')].map { |i| File.read(i) }.join("\n")
constructor = IdeaMachine::Constructor.new(files, :disallow_duplicates => true, :debug => true)

constructor.generate(10).each do |idea|
  puts idea
  puts
end
