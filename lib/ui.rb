require 'am'

module AM
  class Ui
    def current_config(config)
      al_max_len = 0

      AM::after_break("current commands of the config")

      config.each do |al,command|
        al_max_len  = max(al.to_s.length, al_max_len)
      end

      index_max_len = config.length.to_s.length

      config.each_with_index do|record,index|

        as = ''
        (al_max_len - record[ALIAS].length.to_i).times do as = as + ' ' end
        is = ''
        (index_max_len - (index+1).to_s.length).times  do is = is + ' ' end

        puts " #{is}#{(index+1).to_s} : #{record[ALIAS].to_s}#{as} = #{record[COMMAND].to_s}"
      end
      AM::before_break("")
    end

    def add_command_with_number(commands)
      print 'please input add command number: '
      number     = please_input
      valid?(number, '^[^1-5]', '[error] input using number!')
      alias_name = get_alias
      [alias_name, quot(commands[number.to_i-1])]
    end

    def add_command_with_last_history(command)
      puts "add command is #{quot(command)}"
      alias_name   = get_alias
      [alias_name, quot(command)]
    end

    def del_command_with_number(config)
      print 'please input delete command number: '
      number = please_input
      valid?(number, '^[^0-9]', '[error] input using number!')
      delete_alias = config[number.to_i-1][ALIAS] if config.length >= number.to_i
    end

    def get_alias
      print "please input add command alias: "
      name = please_input
      valid?(name, '^[^\w-]', '[error] input using a-z or 0-9 or _ or -!')
      name
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
