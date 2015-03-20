# encoding: utf-8
require 'am'

module AM
  module MessageControl
    NOTICE_MESSAGE = {
      config_empty: 'config is empty',
      success_add_command: "success! %s / %s added command\n       please run: [ source %s ]",
      success_delete_command: "success! %s delete alias\n       please run: [ source %s ]"
    }
    WARNING_MESSAGE = {
      add_command: "%s / %s couldn't add command",
      empty_config_number: "selected number missing in current config",
      duplecate_alias: "not written as duplecate alias is '%s'",
      duplecate_command: "not written as duplecate command is %s",
    }
    ERROR_MESSAGE = {
      add_command: "%s / %s couldn't add command",
      validate_length_zero: "%s / %s length equal 0",
      faile_delete: "failue delete alias %s",
    }

    def notice(code, val=nil)
      puts "\n" + '-'*60
      print(NOTICE_MESSAGE, 'info', code, val)
      puts '-'*60
    end

    def warning(code, val=nil)
      puts "\n" + '-'*60
      print(WARNING_MESSAGE, 'warning', code, val)
      puts '-'*60
    end
    def error(code, val=nil)
      puts "\n" + '-'*60
      print(ERROR_MESSAGE, 'error', code, val)
      puts '-'*60
      exit
    end

    def print(template, prefix, code, val=nil)
      puts "[#{prefix}] #{template[code]}"%val
    end
  end
end