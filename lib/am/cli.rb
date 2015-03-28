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
      @tail    = Tail.new(@config)
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
    def add
      commands = @tail.get_last_command

      error(:not_exists_history_record) if commands.nil?

      @ui.print_last_commands(commands)
      new_alias = @ui.add_command_with_number(commands)

      unless Hash.try_convert(new_alias)
        add
      else
        @config.add_config(new_alias) if uniq?(new_alias)
      end
    end

    desc "del", "delete alias"
    def del
      unless @config.al.empty?
        @ui.print_current_config(@config)
        delete_alias = @ui.delete_command_with_number(@config)
        unless delete_alias.nil?
          @config.al.delete(delete_alias)
          @config.delete_config(delete_alias)
        else
          del
        end
      else
        notice(:config_empty)
      end
    end
  end
end
