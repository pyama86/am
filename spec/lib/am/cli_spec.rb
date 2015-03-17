# encoding: utf-8 
require 'spec_helper.rb'

describe AM::CLI do
  shared_examples_for "shell test" do
    before do
      ENV['SHELL'] = shell
      add_history
    end

    before(:each) do
      add_alias_config
      @cli = AM::CLI.new
    end

    describe 'show' do
      it 'current' do
        expect { @cli.show }.to output(match_current_config).to_stdout
      end
    end

    describe 'register' do
      describe 'add' do
        before do
          allow(STDIN).to receive(:gets) { "add_command_alias\n" }
          expect { @cli.show }.not_to output(/add_command_alias/).to_stdout
        end
        it 'single' do
          expect { @cli.add }.to  output(/success/).to_stdout
          expect { @cli.add }.to  output(/duplecate/).to_stdout
          expect { @cli.show }.to output(/add_command_alias/).to_stdout
        end
      end
      describe 'delete' do
        before do
          expect { @cli.show }.to output(/ほげ/).to_stdout
        end
        it 'single' do
          expect { @cli.del('ほげ') }.to output(/success/).to_stdout
          expect { @cli.show }.not_to    output(/ほげ/).to_stdout
        end
      end
    end

    describe 'register option' do
      describe 'add' do
        before do
          allow(STDIN).to receive(:gets).and_return("1\n","last_command_alias\n")
          expect { @cli.show }.to_not output(/last_command_alias/).to_stdout
        end
        it 'list' do
          expect { @cli.invoke(:add, [], {list: true}) }.to output(/#{match_last_five_command}/).to_stdout
          expect { AM::CLI.new.show }.to output(/last_command_alias/).to_stdout
        end

      end
      describe 'del' do
        before do
          allow(STDIN).to receive(:gets).and_return("1\n")
          expect { @cli.show }.to output(/hoge/).to_stdout
        end
        it 'list' do
          expect { @cli.invoke(:del, [], {list: true}) }.to output(/#{match_delete_list}/).to_stdout
          expect { AM::CLI.new.show }.to_not output(/hoge/).to_stdout
        end
      end
    end
  end
  describe 'zsh' do
    let(:shell)     {'/bin/zsh' }
    it_should_behave_like 'shell test'
  end

  describe 'bash' do
    let(:shell)     {'/bin/bash' }
    it_should_behave_like 'shell test'
  end
end

