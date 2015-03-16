# encoding: utf-8 
require 'am'

module AM
  class Config
    attr_accessor :al, :pg

    def initialize
      @al = []
      @pg = {}
      load_config
    end

    def load_config
      @al = file_load(CONFIG_FILE)
      buf = file_load(LOCAL_FILE)
      @pg = Hash[buf] unless buf.empty?
    end

    def file_load(file_name)
      buf = []
      File.open(file_name, 'r') do |file|
        file.each_line do |line|
          line = line.strip
          buf    << line.gsub(/^alias /, '').split('=', 2) if line !~ /^$/ && line =~ /.+=.+/ && line !~ /^#.*/
        end
      end if File.exists?(file_name)
      buf
    end

    def save_config(exclude=nil)

      al_result = file_write(CONFIG_FILE, @al, 'alias ', exclude)
      pg_result = file_write(LOCAL_FILE,  @pg)

      if al_result && pg_result
        @al = al_result
        @pg = Hash[pg_result] unless pg_result.empty?
        true
      end
    end

    def file_write(file_name, config, prefix=nil, exclude=nil)
      tmp_file = file_name + '.tmp'
      file = File.open(tmp_file, "w")
      new = []

      config.each do |n,v|
        r = "#{prefix}#{n.to_s}=#{v.to_s}"
        if n.to_s != exclude
          file.puts(r)
          new << [n, v]
        end
      end

      file.close
      new if File.rename(tmp_file, file_name) == 0
    end
  end
end
