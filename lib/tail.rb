# encoding: utf-8 
require 'am'

module AM
  class Tail
    attr_accessor :profile
    def initialize(config)
      @profile = get_profile(config)
    end

    def get_profile(config)
      shell = ENV['SHELL']
      h = case shell
      when /zsh/  then set_hash(0, 5, '~/.zsh_history')
      when /bash/ then set_hash(1, 5, '~/.bash_history')
      else # todo raise
          puts "does not support is #{shell}"
          exit
      end

      h[:file] = f if f =  config.pg['history_file']
      h[:file] = File.expand_path(h[:file])

      unless File.exists?(h[:file])
        #todo raise
        puts "history file not found #{h[:file]}"
        exit
      end
      h
    end

    def set_hash(margin, max_line, history_file)
      return { margin: margin, max_line: max_line, file: history_file }
    end

    def get_last_five_command
      commands = []
      r=""
      last_commands = `tail -#{@profile[:max_line] + 1 - @profile[:margin]} #{@profile[:file]} | head -#{@profile[:max_line]}`.split("\n")
      unless last_commands.empty?
        last_commands.each_with_index do |c,i|
          commands << r if r = sampling(c)
        end
        commands
      end
    end

    def get_last_command
      r=""
      if c = `tail -#{2-@profile[:margin]} #{@profile[:file]} | head -1`
        sampling(c)
      end
    end

    def sampling(command)
      zsh  = '[0-9]+:[0-0];(.*)'
      bash = '(.*)'
      if command =~ /#{zsh}/
        p = zsh
      else
        p = bash
      end
      command.split(/#{p}/)[COMMAND].strip if command.strip !~ /^$/
    end
  end
end
