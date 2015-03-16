# encoding: utf-8 
require 'am'

module AM
  class Config
    attr_accessor :al, :pg

    def initialize
      @al = {}
      @pg = {}
      load_config
    end

    def load_config
      @al = file_load(CONFIG_FILE)
      @pg = file_load(LOCAL_FILE)
    end

    def save_config
      (file_write(CONFIG_FILE, @al, 'alias ') && file_write(LOCAL_FILE,  @pg))
    end

    def file_write(file_name, config, prefix=nil)
      tmp_file = file_name + '.tmp'
      file = File.open(tmp_file, "w")

      config.each do |k,v|
        r = "#{prefix}#{k.to_s}=#{v.to_s}"
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
          buf    << line.gsub(/^alias /, '').split('=', 2) if line !~ /^$/ && line =~ /.+=.+/ && line !~ /^#.*/
        end
      end if File.exists?(file_name)
      Hash[buf]
    end
  end
end
