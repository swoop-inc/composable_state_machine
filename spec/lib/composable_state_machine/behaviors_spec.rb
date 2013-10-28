require 'spec_helper'

describe ComposableStateMachine::Behaviors do

  describe 'initialization' do
    it 'accepts callables for different behaviors' do
      callable = proc {}
      behaviors = described_class.new(enter: callable, leave: callable)

      callable.should_receive(:call).twice

      behaviors.call(nil, :enter)
      behaviors.call(nil, :leave)
    end

    it 'creates callbacks from non-callables by default' do
      func = proc{}

      ComposableStateMachine::Callbacks.should_receive(:new).with({x: func})

      described_class.new(enter: {x: func})
    end

    it 'accepts an alternative callbacks factory' do
      func = proc{}
      callbacks_factory = double(new: double)

      callbacks_factory.should_receive(:new).with({x: func})

      described_class.new({enter: {x: func}}, callbacks_factory)
    end
  end

  describe '#on' do
    it 'forwards to callbacks' do
      func = proc{}
      callbacks = ComposableStateMachine::Callbacks.new
      behaviors = described_class.new(enter: callbacks)

      callbacks.should_receive(:on).with(:a, func).once

      behaviors.on(:enter, :a, func)
      behaviors.on(:leave, :a, proc {})
    end

    it 'creates new callbacks for new behaviors' do
      func = proc{}
      ComposableStateMachine::Callbacks.tap do |callback_factory|
        callback_factory.should_receive(:new).and_call_original
        callback_factory.any_instance.should_receive(:on).with(:a, func)
      end

      behaviors = described_class.new
      behaviors.on(:enter, :a, func)
    end
  end

  describe '#call' do
    it 'accepts unknown triggers' do
      behaviors = described_class.new

      expect do
        behaviors.call(nil, :enter, :a)
      end.not_to raise_error
    end

    it 'returns self' do
      behaviors = described_class.new

      behaviors.call(nil, :enter, :a).should eq behaviors
    end

    it 'passes any arguments to the callback' do
      func = proc {}
      behaviors = described_class.new(enter: func)

      func.should_receive(:call).with(nil, :a, 1, 2, 3)

      behaviors.call(nil, :enter, :a, 1, 2, 3)
    end
  end

end
