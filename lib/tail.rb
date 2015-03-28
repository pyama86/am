# encoding: utf-8
require 'am'
require 'message_control'

module AM
  class Tail
    include MessageControl
    attr_accessor :profile

    def initialize(config)
      @profile = get_profile(config)
    end

    def get_profile(config)
      shell = ENV['SHELL']
      profile = case shell
      when /zsh/  then set_hash(0, '~/.zsh_history')
      when /bash/ then set_hash(1, '~/.bash_history')
      else
          error(:no_support, shell)
      end
      profile[:file] = File.expand_path(config.pg['history_file'] || profile[:file])

      unless File.exists?(profile[:file])
        error(:not_exists_history_file, profile[:file])
        exit
      end
      profile
    end

    def set_hash(margin,  history_file)
      return { margin: margin, file: history_file }
    end

    def get_last_command
      commands = []
      last_commands = `tail -#{TAIL_LINE + 1 - @profile[:margin]} #{@profile[:file]} | head -#{TAIL_LINE}`.split("\n")
      unless last_commands.empty?
        last_commands.each_with_index do |c,i|
          r = sampling(c)
          commands << r if r
        end
        commands
      end
    end

    def sampling(command)
      zsh  = '[0-9]+:[0-0];(.*)'
      bash = '(.*)'
      if command =~ /#{zsh}/
        pattern = zsh
      else
        pattern = bash
      end
      command.split(/#{pattern}/)[COMMAND].strip if command.strip !~ /^$/
    end
  end
end
