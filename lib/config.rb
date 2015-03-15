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

    def save_config(config, exclude=nil)
      tmp_file = CONFIG_FILE + '.tmp'
      file = File.open(tmp_file, "w")

      config.each do |a,c|
        r = "alias #{a.to_s}=#{c.to_s}"
        if a.to_s != exclude
          file.puts(r)
        end
      end

      file.close
      File.rename(tmp_file, CONFIG_FILE)
    end
  end
end
