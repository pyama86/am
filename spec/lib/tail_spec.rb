require 'spec_helper.rb'

describe AM::Tail do
  context 'tail commands tests' do
    shared_examples_for "shell test" do
      before do
        ENV['SHELL'] = shell
        @tail = AM::Tail.new(AM::Config.new)
        add_history(@tail.profile[:file])
      end

      it 'get_last_five_commands' do
        expect(@tail.get_last_five_command.length).to eq 5
        expect(@tail.get_last_five_command[0]).to match(/[a-z]+/)
      end

      it 'get_last_command' do
        expect(@tail.get_last_command.length).to be >= 1
        expect(@tail.get_last_command[0]).to match(/[a-z]+/)
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
end

