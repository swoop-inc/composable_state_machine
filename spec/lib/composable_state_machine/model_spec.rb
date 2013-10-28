require 'spec_helper'

describe ComposableStateMachine::Model do

  let(:transition_map) do
    {
        heat: {
            cold: :warm,
            warm: :hot,
            hot: :hot,
        },
        cool: {
            cold: :cold,
            warm: :cold,
            hot: :warm
        }
    }
  end
  let(:transitions) { ComposableStateMachine::Transitions.new(transition_map) }
  let(:behaviors) { double(call: nil) }

  subject do
    described_class.new(initial_state: :cold,
                        transitions: transitions, behaviors: behaviors)
  end

  describe '#initial_state' do
    it 'stores the initial state of the model' do
      subject.initial_state.should eq :cold
    end
  end

  describe '#transition' do

    it 'forwards to transitions' do
      transitions.should_receive(:transition).with(:cold, :heat)

      subject.transition(:cold, :heat)
    end

    it 'executes :enter behaviors with the new state and the event to behaviors' do
      behaviors.should_receive(:call).with(
          ComposableStateMachine::DefaultCallbackRunner,
          :enter, :warm, :cold, :heat, :warm)

      subject.transition(:cold, :heat).should eq :warm
    end

    it 'yields the new state on state change' do
      expect do |b|
        subject.transition(:cold, :heat, &b)
      end.to yield_with_args(:warm)
    end

    it 'does not execute :enter behaviors when the state does not transition' do
      behaviors.should_not_receive(:call)

      subject.transition(:cold, :cool).should eq :cold
    end

    it 'does not yield if there is no state change' do
      expect do |b|
        subject.transition(:cold, :cool, &b)
      end.not_to yield_control
    end

    it 'can send optional event arguments and callback runner' do
      runner = double

      behaviors.should_receive(:call).with(runner, :enter, :warm, :cold, :heat, :warm, 1, 2, 3)

      subject.transition(:cold, :heat, [1, 2, 3], runner).should eq :warm
    end
  end

end
