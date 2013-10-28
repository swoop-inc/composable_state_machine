require 'spec_helper'

describe ComposableStateMachine::Machine do

  describe '#initialization' do
    it 'can set the initial state' do
      model = double(callback_runner: proc {})
      machine = described_class.new(model, state: :test_state)

      machine.should be_kind_of ComposableStateMachine::MachineWithExternalState
      machine.state.should eq :test_state
    end

    it 'delegates to MachineWithExternalState hooking up #state updates' do
      model = ComposableStateMachine.model(
          initial_state: :first, transitions: {next: {first: :second}})
      machine = described_class.new(model)

      machine.state.should eq :first
      machine.trigger(:next).should eq :second
      machine.state.should eq :second
    end
  end

end
