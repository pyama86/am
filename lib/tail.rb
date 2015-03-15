require 'am'

module AM
  class Tail
    def initialize(*args)
      set_profile
    end

    def set_profile
      shell = `echo $SHELL`
      if shell =~ /zsh/
        @history_pattern = '.*;(.*)'
        @sh_history_file = File.expand_path('~/.zsh_history')
        @tail_margin     = 0
      elsif shell =~ /bash/
        @history_pattern = '(.*)'
        @sh_history_file = File.expand_path('~/.bash_history')
        @tail_margin     = 1
      else
        puts "does not support is #{shell}"
      end
    end

    def print_last_commands
      exit if @sh_history_file.nil?

      commands = []
      last_commands = `tail -#{6-@tail_margin} #{@sh_history_file} | head -5`.split("\n")
      last_commands.each_with_index  do |c,i|
        record = c.split(/#{@history_pattern}/)[COMMAND].strip
        puts " #{(i+1).to_s} : #{record.to_s}"
        commands << record
      end
      commands
    end

    def get_last_command
      exit if @sh_history_file.nil?
      `tail -#{2-@tail_margin} #{@sh_history_file} | head -1`.split(/#{@history_pattern}/)[COMMAND].strip
    end

  end
end
