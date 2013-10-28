require 'spec_helper'

describe ComposableStateMachine::MachineWithExternalState do

  let(:transitions) do
    ComposableStateMachine::Transitions.new(
        {
            hire: {candidate: :hired},
            leave: {hired: :departed},
            fire: {hired: :fired},
        }
    )
  end

  let(:model) do
    ComposableStateMachine::Model.new(
        initial_state: :candidate,
        transitions: transitions
    )
  end

  let(:model_with_behavior) do
    ComposableStateMachine::Model.new(
        initial_state: :candidate,
        transitions: transitions,
        behaviors: ComposableStateMachine::Behaviors.new(
            {
                enter: {hired: proc {}}
            }
        )
    )
  end

  before do
    @state = nil
    @state_reader = lambda { @state }
    @state_writer = lambda { |new_state| @state = new_state }
  end

  describe '#initialization' do
    it 'sets the state to the initial state of the model by default' do
      described_class.new(model, @state_reader, @state_writer)

      @state.should eq :candidate
    end

    it 'can set the initial state' do
      described_class.new(model, @state_reader, @state_writer, state: :hired)

      @state.should eq :hired
    end

    it 'can specify the callback runner' do
      runner = double(run_state_machine_callback: nil)
      machine = described_class.new(model_with_behavior, @state_reader, @state_writer,
                                    callback_runner: runner, state: :candidate)

      runner.should_receive(:run_state_machine_callback).with(an_instance_of(Proc), :candidate, :hire, :hired)

      machine.trigger(:hire)
    end
  end

  describe 'main API' do
    subject { described_class.new(model, @state_reader, @state_writer) }

    describe '#trigger' do
      it 'transitions via the model' do
        model.should_receive(:transition).with(
            :candidate, :hire, [], ComposableStateMachine::DefaultCallbackRunner).
            and_call_original

        subject.trigger(:hire).should eq :hired
      end

      it 'updates the state when a transition is made' do
        subject.trigger(:hire)

        @state.should eq :hired
      end

      it 'does not update the state when a transition is not made' do
        subject.trigger(:hire)

        subject.trigger(:hire).should be_nil
        @state.should eq :hired
      end
    end

    describe '#==' do
      it 'compares equality based on the state' do
        subject.should == :candidate
      end
    end
  end

end
