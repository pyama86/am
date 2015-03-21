# encoding: utf-8
require 'spec_helper.rb'

describe AM::CLI do
  shared_examples_for "shell test" do
    before(:each) do
      add_alias_config
      @cli = AM::CLI.new
    end

    describe 'show' do
      it 'current' do
        expect { @cli.show }.to output(match_current_config).to_stdout
      end
    end

    describe 'register option' do
      describe 'add' do
        before do
          allow(STDIN).to receive(:gets).and_return("1\n","last_command_alias\n")
          expect { @cli.show }.to_not output(/last_command_alias/).to_stdout
        end
        it 'list' do
          expect { @cli.add }.to output(/#{match_last_command}/).to_stdout
          expect { @cli.show }.to output(/last_command_alias/).to_stdout
        end
      end
      describe 'del' do
        before do
          allow(STDIN).to receive(:gets).and_return("1\n")
          expect { @cli.show }.to output(/hoge/).to_stdout
        end
        it 'list' do
          expect { @cli.del }.to output(/#{match_delete_list}/).to_stdout
          expect { @cli.show }.to_not output(/hoge/).to_stdout
        end
      end
    end
  end
  describe 'zsh' do
    ENV['SHELL'] = '/bin/zsh'
    add_history
    hist_file = File.expand_path('~/.zsh_history')
    file_write(hist_file,'abcd ABCD 1234 あいうえ', 'a')
    it_should_behave_like 'shell test'
  end

  describe 'bash' do
    ENV['SHELL'] = '/bin/bash'
    add_history
    it_should_behave_like 'shell test'
  end
end

