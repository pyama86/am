require 'spec_helper.rb'

describe AM::Config do
  context 'zsh' do
    before do
      `echo "alias test1='test az - AZ 09 _'" > #{AM::CONFIG_FILE}`
      `echo "history_file=~/.zsh_history" >  #{AM::LOCAL_FILE}`
      @config= AM::Config.new
    end

    it 'load config' do
      expect(@config.al[0][0]).to eq 'test1'
      expect(@config.al[0][1]).to eq "'test az - AZ 09 _'"
      expect(@config.pg['history_file']).to eq "~/.zsh_history"
    end

    it 'save config'do
      # add
      config = @config.al << ['test2', "'abcdefgeijklmn'"]
      expect(@config.save_config).to be true
      expect(@config.al.length).to eql(2)

      # delete
      expect(@config.save_config('test1')).to be true
      expect(@config.al.length).to eql(1)

      # valu check
      expect(@config.al[0][0]).to eq 'test2'
      expect(@config.al[0][1]).to eq "'abcdefgeijklmn'"
      expect(@config.pg['history_file']).to eq "~/.zsh_history"

    end

    it 'pg config' do
      # @config.pg_check
      `echo "history_file=~/.csh_history" > #{AM::LOCAL_FILE}`
      config= AM::Config.new
      expect(config.pg['history_file']).to eq "~/.csh_history"
      `echo "" > #{AM::LOCAL_FILE}`
    end
  end
end

