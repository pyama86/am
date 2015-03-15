require "am/version"
require "am/cli"
module AM 
  # Your code goes here...
  CONFIG_FILE=File.expand_path('~/.am_config')
  ALIAS   = 0
  COMMAND = 1
  def self.before_break(message)
    puts "\n#{message}"
  end
  def self.after_break(message)
    puts "#{message}\n\n"
  end
end
