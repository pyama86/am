require 'am'

module AM
  class Config
    attr_accessor :al, :pg
    def initialize
      file_load
    end

    def file_load
      @al = []
      @pg = {}
      File.open(CONFIG_FILE, 'r') do |file|

        file.each_line do |line|
          @al  << line.gsub(/^alias /, '').strip.split('=', 2) if(line =~ /^alias/)
          @pg   = Hash[*line.strip.split('=', 2)] if line =~ /^[^alias]/ && line =~ /^[^#.*]/
        end

      end if File.exists?(CONFIG_FILE)
    end

    def save_config(exclude=nil)
      tmp_file = CONFIG_FILE + '.tmp'
      file = File.open(tmp_file, "w")
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

      file.puts("\n# pg config")
      @pg.each do |p,v|
        r = "#{p.to_s}=#{v.to_s}"
        file.puts(r)
      end
      file.close
      File.rename(tmp_file, CONFIG_FILE)
    end
  end
end
