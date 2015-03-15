require 'am'

module AM
  class Config

    def current
      config = []
      File.open(CONFIG_FILE, 'r') do |file|
        file.each_line do |line|
          config << line.gsub(/^alias /, '').strip.split('=', 2)
        end
      end if File.exists?(CONFIG_FILE)
      config
    end

    def save_config(cache, exclude=nil)
      tmp_file = CONFIG_FILE + '.tmp'
      file = File.open(tmp_file, "w")

      cache.each do |al, command|
        record = "alias #{al.to_s.strip}=#{command.to_s.strip}"
        if al.to_s.strip != exclude
          file.puts(record) 
        end
        `#{record}`
      end
      file.close
      File.rename(tmp_file, CONFIG_FILE)
    end
  end
end
