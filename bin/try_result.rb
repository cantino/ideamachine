require File.dirname(__FILE__) + '/../lib/idea_machine'

structure = Dir[File.dirname(__FILE__) + '/../config/ideas/**/*.txt'].map {|i| File.read(i)}.join("\n")
constructor = IdeaMachine::Constructor.new(structure)
puts constructor.generate((ARGV[1] || 20).to_i, (ARGV.first ? ARGV.first.to_i : nil)).map{|i| i.gsub(/\<.*?\>/, '')}.sort.uniq.join("\n")
