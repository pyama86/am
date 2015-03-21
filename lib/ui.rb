# encoding: utf-8
require 'am'
require 'validate'

module AM
  class Ui
    include MessageControl
    include Validate

    def print_current_config(config)
      aml = config.al.max_by{|c| c[0].length }[0].length #alias max length
      iml = config.al.length.to_s.length                 #index max length
      arr = []                                           #use delete number

      before_sepalate
      puts 'current registered alias'
      config.al.each_with_index do|(k,v),i|
        # 1: name=command
        puts " #{' '*(iml - (i+1).to_s.length)}#{(i+1).to_s} : #{k.to_s}#{' '*(aml-k.length)} = #{v.to_s}"
        arr << [i,k]
      end
      after_sepalate
      arr
    end

    def print_last_commands(commands)
      iml = commands.length.to_s.length                 #index max length

      before_sepalate
      puts 'current history commands'
      commands.each_with_index  do |c,i|
        puts " #{' '*(iml - (i+1).to_s.length)}#{(i+1).to_s} : #{c.to_s}"
      end
      after_sepalate
    end

    def add_command_with_number(commands)
      number = get_number

      if valid?(number, "^[^0-9]+$")
        warning(:validate_number)
      elsif number.to_i > TAIL_LINE || number.to_i <= 0
        warning(:validate_number_range, TAIL_LINE)
      else
        alias_name = get_alias
        {alias_name => quot(commands[number.to_i-1].strip)}
      end

    end

    def del_command_with_number(arr)
      number = get_number

      if valid?(number, "^[1-9]+$")
        arr[number.to_i-1][1] if arr.length >= number.to_i
      else
        warning(:validate_number)
      end
    end

    def get_number
      print 'please select number: '
      get_stdin
    end

    def get_alias
      print "please input command alias name: "
      alias_name = get_stdin
      if valid?(alias_name, '^[\w-]+$')
        alias_name.strip
      else
        warning(:validate_alias)
        get_alias
      end
    end


    def get_stdin
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
