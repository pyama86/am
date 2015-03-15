require 'am'

module AM
  class Tail
    def initialize(config)
      set_profile(config)
    end

    def set_profile(config)
      shell = ENV['SHELL']
      @profile = {}

      if shell =~ /zsh/
        @profile = {
          pattern:  '.*;(.*)',
          margin:   0,
          max_line: 5,
          file:     '~/.zsh_history'
        }
      elsif shell =~ /bash/
        @profile = {
          pattern:  '(.*)',
          margin:   1,
          max_line: 5,
          file:     '~/.bash_history'
        }
      else
        puts "does not support is #{shell}"
        exit
      end

      @profile[:file] = config.pg['history_file'] unless config.pg['history_file'].nil?
      @profile[:file] = File.expand_path(@profile[:file])

      unless File.exists?(@profile[:file])
        puts "history file not found #{@profile[:file]}"
        exit
      end
    end

    def get_last_five_command
      exit if @profile.empty?
      commands = []
      last_commands = `tail -#{@profile[:max_line] + 1 - @profile[:margin]} #{@profile[:file]} | head -#{@profile[:max_line]}`.split("\n")

      last_commands.each_with_index  do |c,i|
        record = c.split(/#{@profile[:pattern]}/)[COMMAND].strip
        commands << record
      end unless last_commands.empty?

      commands
    end

    def get_last_command
      exit if @profile[:file].empty?

      if last_row = `tail -#{2-@profile[:margin]} #{@profile[:file]} | head -1`.split(/#{@profile[:pattern]}/)
        last_row[COMMAND].strip
      end
    end
  end
end
