# encoding: utf-8
require 'am'

module AM
  module MessageControl
    NOTICE_MESSAGE = {
      config_empty: 'config is empty',
      success_add_command: "success! %s / %s added command\n       please run: [ aml ] or [ source %s ]",
      success_delete_command: "success! %s delete alias\n       please run: [ source %s ]"
    }
    WARNING_MESSAGE = {
      add_command: "%s / %s couldn't add command",
      empty_config_number: "selected number missing in current config",
      validate_number: "please input using number",
      validate_number_range: "please input number 1-%s",
      validate_alias: 'input using a-z or 0-9 or _ or -',
    }
    ERROR_MESSAGE = {
      add_command_fail: "%s / %s couldn't add command",
      validate_length_zero: "%s / %s length equal 0",
      delete_command_fail: "fail delete alias %s",
      duplicate_alias: "duplicate alias is '%s'",
      duplicate_command: "duplicate command is %s",
      no_support: "does not support is %s",
      not_exists_history_file: "history file not found %s",
      not_exists_history_record: "history record not exists"
    }

    def notice(code, val=nil)
      print_message(NOTICE_MESSAGE, 'info', code, val)
    end

    def warning(code, val=nil)
      print_message(WARNING_MESSAGE, 'warning', code, val)
    end
    def error(code, val=nil)
      print_message(ERROR_MESSAGE, 'error', code, val)
      exit
    end

    def print_message(template, prefix, code, val=nil)
      before_sepalate
      puts "[#{prefix}] #{template[code]}"%val
      after_sepalate
    end

    def before_sepalate
      puts ''
      puts '='*60
    end

    def after_sepalate
      puts '='*60
      puts ''
    end

  end
end
