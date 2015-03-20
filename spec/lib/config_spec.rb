require 'spec_helper.rb'

describe AM::Config do
  shared_examples_for 'config test' do
    before do
      ENV['SHELL'] = shell
    end
    describe 'alias config' do
      describe 'load config' do
        before do
          file_write(AM::CONFIG_FILE,"alias test1='test az - AZ 09 _", 'w')
          config= AM::Config.new
          @ak,@av = config.al.first
          config.save_config
          @all_config = file_load(AM::CONFIG_FILE)
        end
        it 'load' do
          expect(@ak).to eq 'test1'
          expect(@av).to eq "'test az - AZ 09 _"
          expect(@all_config.key?('aml')).to be true
          expect(@all_config['aml']).to eq "'source ~/.am_config'"
        end
      end

      describe 'save config'do
        before do
          file_write(AM::CONFIG_FILE,"alias test1='test az - AZ 09 _", 'w')
          @config= AM::Config.new
          @config.al.merge!({'test2' => "'abcdefgeijklmn'"})
        end
        it 'add' do
          expect(@config.save_config).to be true
          expect(@config.al.length).to eql(2)
          expect(@config.al.key?('test2')).to be true
          expect(@config.al['test2']).to eq "'abcdefgeijklmn'"
        end
        it 'delete' do
          @config.al.delete('test1')
          expect(@config.save_config()).to be true
          expect(@config.al.length).to eql(1)
          expect(@config.al.key?('test2')).to be true
          expect(@config.al['test2']).to eq "'abcdefgeijklmn'"
        end
      end
    end
  end

  describe 'pg config' do
    describe 'load config' do
      before do
        file_write(AM::LOCAL_FILE, "history_file=~/.csh_history", 'w')
        @config= AM::Config.new
        @pk,@pv = @config.pg.first
      end
      it 'load config' do
        expect(@pk).to eq 'history_file'
        expect(@pv).to eq "~/.csh_history"
      end
    end
    after do
      file_write(AM::LOCAL_FILE, '','w');
    end
  end
  describe 'zsh' do
    let(:shell)     {'/bin/zsh' }
    it_should_behave_like 'config test'
  end

  describe 'bash' do
    let(:shell)     {'/bin/bash' }
    it_should_behave_like 'config test'
  end
end
