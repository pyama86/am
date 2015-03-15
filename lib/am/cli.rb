require 'am'
require 'tail'
require 'config'
require 'ui'
require 'thor'

module AM
  class CLI < Thor
    default_command :show
    def initialize(*args)
      super
      config  = Config.new
      @config = config.current
      @ui     = Ui.new
    end

    desc "show", "show current alias"
    def show
      if @config.empty?
        puts 'a blank config'
      else
        @ui.current_config(@config)
      end
    end

    desc "add", "add alias"
    option :list, :type => :boolean, :aliases => '-l'
    def add
      tail = Tail.new
      # registeration from history choice
      if options[:list]
        commands = tail.print_last_commands
        add_record = @ui.add_command_with_number(commands)
      # registeration from last history
      else
        last_command = tail.get_last_command
        add_record   = @ui.add_command_with_last_history(last_command)
      end

      if uniq?(add_record)
        @config << add_record
        add_config(add_record) 
      else
        AM.before_break("")
        show
      end
    end

    desc "del", "delete alias"
    option :list, :type => :boolean, :aliases => '-l'

    def del(delete_alias=nil)
      if @config.empty?
        puts 'a blank config'
        exit
      end

      if options[:list] || delete_alias == nil
        @ui.current_config(@config)
        delete_alias = @ui.del_command_with_number(@config)
      end
        delete_config(delete_alias)
    end

    no_commands do

      def add_config(add_record)
        config  = Config.new
        if config.save_config(@config)
          AM.before_break("[success] #{add_record[ALIAS]} / #{add_record[COMMAND]} added command")
          AM.after_break("please run: [ source #{CONFIG_FILE} ]")
        else
          puts   "[error] #{add_record[ALIAS]} / #{add_record[COMMAND]} couldn't add command" 
        end
      end

      def delete_config(exclude)
        config  = Config.new
        if config.save_config(@config, exclude)
          AM.before_break("[success] delete alias #{exclude}")
          AM.after_break("please run: [ source #{CONFIG_FILE} ]")
        else
          AM.after_break("[error] failue delete alias #{exclude}}")
        end
      end

      def uniq?(add_record)
        @config.each do |al, command|
          if add_record[ALIAS] == al
            AM.before_break("[error] not written as duplecate alias is '#{add_record[ALIAS]}'")
            return false
          elsif add_record[COMMAND] == command
            AM.before_break("[error] not written as duplecate command is #{add_record[COMMAND]}")
            return false
          end
        end
        return true
      end
    end

  end
end