require 'am'

module AM
  class Config
    attr_accessor :al, :pg
    def initialize
      file_load
    end

    def file_load
      @al    = []
      @pg    = {} 
      pg_buf = []

      # load alias config
      File.open(CONFIG_FILE, 'r') do |file|
        file.each_line do |line|
          @al    << line.gsub(/^alias /, '').strip.split('=', 2) if(line =~ /^alias/)
          # migration
          pg_buf << line.strip.split('=', 2) if line.strip =~ /^[^alias]/ && line.strip =~ /^[^#.*]/ && line.strip !~ /^$/
        end
      end if File.exists?(CONFIG_FILE)

      # load program config
      File.open(LOCAL_FILE, 'r') do |file|
        file.each_line do |line|
          pg_buf << line.strip.split('=', 2) if line.strip =~ /^[^alias]/ && line.strip =~ /^[^#.*]/ && line.strip !~ /^$/
        end
      end if File.exists?(LOCAL_FILE)
      @pg   = Hash[pg_buf] unless pg_buf.empty?
    end

    def save_config(exclude=nil)
      config_tmp_file = CONFIG_FILE + '.tmp'
      file = File.open(config_tmp_file, "w")
      new_al = []

      file.puts("# alias config")
      @al.each do |a,c|
        r = "alias #{a.to_s}=#{c.to_s}"
        if a.to_s != exclude
          file.puts(r)
          new_al << [a, c]
        end
      end
      @al = new_al
      file.close

      local_tmp_file = LOCAL_FILE + '.tmp'
      file = File.open(local_tmp_file, "w")
      file.puts("\n# pg config")
      @pg.each do |p,v|
        r = "#{p.to_s}=#{v.to_s}"
        file.puts(r)
      end
      file.close
      (File.rename(config_tmp_file, CONFIG_FILE) == 0 && File.rename(local_tmp_file, LOCAL_FILE) == 0)
    end
  end
end
