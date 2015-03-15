require "am/version"
require "am/cli"
module AM 

  CONFIG_FILE=File.expand_path('~/.am_config')
  ALIAS   = 0
  COMMAND = 1

  def self.p1(message="")
    puts "\n#{message}"
  end

  def self.p2(message="")
    puts "#{message}\n\n"
  end
end
