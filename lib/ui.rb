# encoding: utf-8 
require 'am'

module AM
  class Ui
    def print_current_config(config)
      aml = config.al.max_by{|c| c[0].length }[0].length #alias max length
      iml = config.al.length.to_s.length                 #index max length

      AM::p1("current commands of the config")
      config.al.each_with_index do|r,i|
        # 1: name=command
        puts " #{' '*(iml - (i+1).to_s.length)}#{(i+1).to_s} : #{r[ALIAS].to_s}#{' '*(aml-r[ALIAS].length)} = #{r[COMMAND].to_s}"
      end unless config.al.empty?
      AM::p1
    end

    def print_last_commands(commands)
      commands.each_with_index  do |c,i|
        puts " #{(i+1).to_s} : #{c.to_s}"
      end unless commands.empty?
    end

    def add_command_with_number(commands)
      print 'please input add command number: '
      number     = please_input
      valid?(number, '^[^1-5]', '[error] input using number!')
      alias_name = get_alias
      [alias_name, quot(commands[number.to_i-1].strip)]
    end

    def add_command_with_last_history(command)
      puts "add command is #{quot(command.strip)}"
      alias_name   = get_alias
      [alias_name, quot(command)]
    end

    def del_command_with_number(config)
      print 'please input delete command number: '
      number = please_input
      valid?(number, '^[^0-9]', '[error] input using number!')
      delete_alias = config.al[number.to_i-1][ALIAS] if config.al.length >= number.to_i
    end

    def get_alias
      print "please input add command alias: "
      name = please_input
      valid?(name, '[^\w-]', '[error] input using a-z or 0-9 or _ or -')
      name.strip
    end

    def valid?(val, pattern, message)
      if /#{pattern}/ =~ val || val.length == 0
        puts message
        exit
      end
    end

    def please_input
      while val = STDIN.gets
        break if /\n$/ =~ val 
      end
      val.strip
    end

    def quot(val)
      "'#{val.to_s}'"
    end

    def max(a, b)
      (a.to_i > b.to_i) ? a : b
    end
  end
end
