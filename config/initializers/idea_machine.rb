require File.join(RAILS_ROOT, 'lib/idea_machine')

structure = Dir[File.join(RAILS_ROOT,'config/ideas/**/*.txt')].map {|i| File.read(i)}.join("\n")
CONSTRUCTOR = IdeaMachine::Constructor.new(structure)
