require 'spec_helper.rb'
describe AM::Tail do
  shared_examples_for "tail test" do
    before do
      ENV['SHELL'] = shell
      @tail = AM::Tail.new(AM::Config.new)
      add_history
    end

    it 'get_last_commands' do
      expect(@tail.get_last_command.length).to eq AM::TAIL_LINE
      expect(@tail.get_last_command[0]).to match(/[a-z]+/)
    end

  end

  describe 'zsh' do
    let(:shell)     {'/bin/zsh' }
    it_should_behave_like 'tail test'
  end

  describe 'bash' do
    let(:shell)     {'/bin/bash' }
    it_should_behave_like 'tail test'
  end
end

