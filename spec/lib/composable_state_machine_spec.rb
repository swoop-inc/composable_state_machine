require 'spec_helper'

describe ComposableStateMachine do

  let(:options) do
    {
        initial_state: :foo,
        transitions: ComposableStateMachine::Transitions.new({}),
        behaviors: ComposableStateMachine::Behaviors.new({}),
        callback_runner: proc {}
    }
  end

  describe '.model' do
    it 'creates a model' do
      ComposableStateMachine::Model.should_receive(:new).with(options).and_call_original

      result = described_class.model(options)
      result.should be_kind_of(ComposableStateMachine::Model)
    end

    it 'creates a Transitions object if necessary' do
      options[:transitions] = {}

      ComposableStateMachine::Model.should_receive(:new) do |options|
        options[:transitions].should be_kind_of(ComposableStateMachine::Transitions)
      end

      described_class.model(options)
    end

    it 'creates a Behaviors object if necessary' do
      options[:behaviors] = {}

      ComposableStateMachine::Model.should_receive(:new) do |options|
        options[:behaviors].should be_kind_of(ComposableStateMachine::Behaviors)
      end

      described_class.model(options)
    end
  end

  describe '.machine' do
    it 'creates a machine from a model' do
      model = described_class.model(options)

      ComposableStateMachine::Machine.should_receive(:new).with(model, initial_state: :bar).and_call_original

      result = described_class.machine(model, initial_state: :bar)
      result.should be_kind_of(ComposableStateMachine::Machine)
    end
  end
end
