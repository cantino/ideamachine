#!/usr/bin/env ruby
require 'rubygems'
require 'linguistics'
Linguistics::use( :en )

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'idea_machine')

files = Dir[File.join(File.dirname(__FILE__), 'parts', '*.txt')].map { |i| File.read(i) }.join("\n")
constructor = IdeaMachine::Constructor.new(files)

constructor.generate(10, :disallow_duplicates => true).each do |idea|
  puts idea
  puts
end