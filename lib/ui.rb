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

      puts 'current registered alias'
      config.al.each_with_index do|(k,v),i|
        # 1: name=command
        puts " #{' '*(iml - (i+1).to_s.length)}#{(i+1).to_s} : #{k.to_s}#{' '*(aml-k.length)} = #{v.to_s}"
      end
      after_sepalate
    end

    def print_last_commands(commands)
      iml = commands.length.to_s.length                 #index max length

      puts 'current history commands'
      commands.each_with_index  do |c,i|
        puts " #{' '*(iml - (i+1).to_s.length)}#{(i+1).to_s} : #{c.to_s}"
      end
      after_sepalate
    end

    def add_command_with_number(commands)
      number = get_number

      if number.to_i > TAIL_LINE
        warning(:validate_number_range, TAIL_LINE)
      else
        alias_name = get_alias
        {alias_name => quot(commands[number.to_i-1].strip)}
      end
    end

    def delete_command_with_number(config)
      number = get_number
      if config.al.length >= number.to_i && config.al.key?(config.al.to_a[number.to_i-1][0])
        config.al.to_a[number.to_i-1][0]
      else
        warning(:empty_config_number)
      end
    end

    def get_number
      print 'please select number: '
      number = get_stdin
      if valid?(number, "^[^0-9]+$") || number.to_i <= 0
        warning(:validate_number)
        get_number
      else
        number
      end
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
