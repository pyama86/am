# encoding: utf-8
require 'am'
require 'message_control'

module AM
  class Config
    include MessageControl
    attr_accessor :al, :pg

    def initialize
      load_config
    end

    def load_config
      @al = file_load(CONFIG_FILE)
      @pg = file_load(LOCAL_FILE)
      @al.delete('aml')
    end

    def add_config(new_alias)
      @al.merge!(new_alias)
      if save_config
        notice(:success_add_command, [new_alias.first.to_a, CONFIG_FILE].flatten)
      else
        error(add_command,[ak, av])
      end
    end

    def delete_config(del_alias)
      @al.delete(del_alias)
      if save_config
        notice(:success_delete_command, [del_alias, CONFIG_FILE])
      else
        error(:fail_delete, del_alias)
      end
    end

    def save_config
      (
        file_write(CONFIG_FILE, @al.merge({"aml" => "'source ~/.am_config'"}))
      )
    end

    def file_write(file_name, config)
      tmp_file = file_name + '.tmp'
      file = File.open(tmp_file, "w")

      config.each do |k,v|
        r = "alias #{k.to_s}=#{v.to_s}"
        file.puts(r)
      end

      file.close
      (File.rename(tmp_file, file_name) == 0)
    end

    def file_load(file_name)
      buf = []
      File.open(file_name, 'r') do |file|
        file.each_line do |line|
          line = line.strip
          buf << line.gsub(/^alias /, '').split('=', 2) if line !~ /^$/ && line =~ /.+=.+/ && line !~ /^#.*/
        end
      end if File.exists?(file_name)
      Hash[buf]
    end
  end
end
