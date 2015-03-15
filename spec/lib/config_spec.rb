require 'spec_helper.rb'

describe AM::Config do
  describe 'config commands tests' do
    before() do
      @config= AM::Config.new
      `echo "alias test1='test az - AZ 09 _'" > #{AM::CONFIG_FILE}`
    end
    it 'load config' do
      @config.current
      expect(@config.current[0][0]).to eq 'test1'
      expect(@config.current[0][1]).to eq "'test az - AZ 09 _'"
    end
    it 'save config'do
      # add
      config = @config.current << ['test2',"'abcdefgeijklmn'"]
      expect(@config.save_config(config)).to eql(0)
      expect(@config.current.length).to eql(2)

      # delete
      expect(@config.save_config(config,'test1')).to eql(0)
      expect(@config.current.length).to eql(1)

      # add check
      expect(@config.current[0][0]).to eq 'test2'
      expect(@config.current[0][1]).to eq "'abcdefgeijklmn'"
    end
  end
end

