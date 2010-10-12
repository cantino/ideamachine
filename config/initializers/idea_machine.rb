require File.join(RAILS_ROOT, 'lib/idea_machine')

class IdeaMachineWrapper
  def initialize
    get_structure
  end

  def get_structure
    structure = Dir[File.join(RAILS_ROOT,'config/ideas/**/*.txt')].map {|i| File.read(i)}.join("\n")
    @constructor = IdeaMachine::Constructor.new(structure)
    puts "Updated structure"
  end

  def generate(*args)
    get_structure if RAILS_ENV == 'development'
    @constructor.generate(*args)
  end
end

CONSTRUCTOR = IdeaMachineWrapper.new
