# encoding: utf-8
require 'am'
require 'tail'
require 'config'
require 'ui'
require 'validate'
require 'message_control'
require 'thor'

module AM
  class CLI < Thor

    include MessageControl
    include Validate

    default_command :show
    def initialize(*args)
      super
      @config  = Config.new
      @ui      = Ui.new
    end

    desc "show", "show current alias"
    def show
      if @config.al.empty?
        notice(:config_empty)
      else
        @ui.print_current_config(@config)
      end
    end

    desc "add", "add alias"
    option :list, :type => :boolean, :aliases => '-l'
    def add
      tail = Tail.new(@config)

      # registeration from history choice
      if options[:list]
        commands = tail.get_last_five_command
        @ui.print_last_commands(commands)
        new_alias = @ui.add_command_with_number(commands)

      # registeration from last history
      else
        last_command = tail.get_last_command
        new_alias   = @ui.add_command_with_last_history(last_command)
      end

      if uniq?(new_alias) && valid?(new_alias)
        @config.add_config(new_alias)
      end
    end

    desc "del", "delete alias"
    option :list, :type => :boolean, :aliases => '-l'
    def del(delete_alias=nil)
      if @config.al.empty?
        notice(:config_empty)
        exit
      end

      if options[:list] || delete_alias == nil
        # convert array
        arr =  @ui.print_current_config(@config)
        delete_alias = @ui.del_command_with_number(arr)
      end
      if delete_alias && @config.al.key?(delete_alias)
        @config.al.delete(delete_alias)
      else
        warning(:empty_config_number)
        self.del
      end
      @config.delete_config(delete_alias)
    end
  end
end
