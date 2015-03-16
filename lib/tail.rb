# encoding: utf-8 
require 'am'

module AM
  class Tail
    attr_accessor :profile
    def initialize(config)
      set_profile(config)
    end

    def set_profile(config)
      shell = ENV['SHELL']
      @profile = {}

      if shell =~ /zsh/
        @profile = {
          margin:   0,
          max_line: 5,
          file:     '~/.zsh_history'
        }
      elsif shell =~ /bash/
        @profile = {
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
        if r = sampling(c)
          commands << r
        end
      end unless last_commands.empty?

      commands
    end

    def get_last_command
      exit if @profile[:file].empty?

      if c = `tail -#{2-@profile[:margin]} #{@profile[:file]} | head -1`
        if r = sampling(c)
          r
        end
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
