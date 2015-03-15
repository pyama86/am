require 'spec_helper.rb'

describe AM::Tail do
  describe 'tail commands tests' do

    before() do
      @tail = AM::Tail.new
    end

    it 'print_last_commands' do
      expect(@tail.get_last_five_command.length).to eq 5
      expect(@tail.get_last_five_command[0]).to match(/[a-z]+/)
    end

    it 'get_last_command' do
      expect(@tail.get_last_command.length).to be >= 1
      expect(@tail.get_last_command[0]).to match(/[a-z]+/)
    end
  end
end

