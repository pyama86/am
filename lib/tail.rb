require 'am'

module AM
  class Tail
    def initialize(*args)
      @sh_history_file = get_history_file
    end

    def get_history_file
      shell = `echo $SHELL`
      if shell =~ /zsh/
        @history_pattern = '.*;(.*)'
        @command_col     = 1
        return File.expand_path('~/.zsh_history')
      elsif shell =~ /bash/
        @history_pattern = '(.*)\n'
        @command_col     = 0
        return File.expand_path('~/.bash_history')
      else
        puts "does not support is #{shell}"
      end
    end

    def print_last_commands
      exit if @sh_history_file.nil?

      commands = []
      last_commands = `tail -6  #{@sh_history_file} | head -5`.split("\n")
      last_commands.each_with_index  do |c,i|
        record = c.split(/#{@history_pattern}/)[@command_col].strip
        puts " #{(i+1).to_s} : #{record.to_s}"
        commands << record
      end
      commands
    end

    def get_last_command
      exit if @sh_history_file.nil?
      `tail -2 #{@sh_history_file} | head -1`.split(/#{@history_pattern}/)[@command_col].strip
    end

  end
end
