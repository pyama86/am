# encoding: utf-8 
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
      @config  = Config.new
      @ui      = Ui.new
    end

    desc "show", "show current alias"
    def show
      if @config.al.empty?
        puts 'a blank config'
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
        add_record = @ui.add_command_with_number(commands)

      # registeration from last history
      else
        last_command = tail.get_last_command
        add_record   = @ui.add_command_with_last_history(last_command)
      end

      if uniq?(add_record) && valid?(add_record)
        @config.al.merge!(add_record)
        add_config(add_record) 
      else
        AM.p1("")
        show
      end
    end

    desc "del", "delete alias"
    option :list, :type => :boolean, :aliases => '-l'
    def del(delete_alias=nil)
      if @config.al.empty?
        puts 'a blank config'
        exit
      end

      if options[:list] || delete_alias == nil
        # convert array
        arr =  @ui.print_current_config(@config)
        delete_alias = @ui.del_command_with_number(arr)
      end
      @config.al.delete(delete_alias)
      delete_config(delete_alias)
    end

    no_commands do
      # todo merge config
      def add_config(add_record)
        ak,av = add_record.first
        if @config.save_config
          AM.p1("[success] #{ak} / #{av} added command")
          AM.p2("please run: [ source #{CONFIG_FILE} ]")

        else
          puts   "[error] #{ak} / #{av} couldn't add command" 
        end
      end

      def delete_config(exclude)
        if @config.save_config
          AM.p1("[success] delete alias #{exclude}")
          AM.p2("please run: [ source #{CONFIG_FILE} ]")

        else
          AM.p2("[error] failue delete alias #{exclude}}")
        end
      end
      # todo end
      # todo move config class
      def uniq?(add_record)
        ak,av = add_record.first
        @config.al.each do |k,v|
          if ak == k
            AM.p1("[error] not written as duplecate alias is '#{ak}'")
            return false
          elsif av == v
            AM.p1("[error] not written as duplecate command is #{av}")
            return false
          end
        end
        true
      end
      # end
      def valid?(add_record)
        ak,av = add_record.first
        unless ak.length > 0 || av.length > 0
          puts   "[error] #{ak} / #{av} length equal 0"
          return false 
        end
        true
      end
    end
  end
end
