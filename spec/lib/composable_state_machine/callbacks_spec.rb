require 'spec_helper'

describe ComposableStateMachine::Callbacks do

  let(:runner) { ComposableStateMachine::DefaultCallbackRunner }

  describe 'initialization' do
    it 'accepts triggers and actions during initialization' do
      func = proc {}
      callbacks = described_class.new(a: func)

      func.should_receive(:call)

      callbacks.call(runner, :a)
    end

    it 'accepts more than one callback per trigger' do
      func = proc {}
      callbacks = described_class.new(a: [func, func, func])

      func.should_receive(:call).exactly(3)

      callbacks.call(runner, :a)
    end
  end

  describe '#on' do
    it 'accepts callables' do
      func = proc {}
      callbacks = described_class.new.
          on(:a, func).
          on(:b, func)

      func.should_receive(:call).twice

      callbacks.call(runner, :a)
      callbacks.call(runner, :b)
    end

    it 'accepts blocks' do
      func = proc {}
      callbacks = described_class.new.
          on(:a, &func)

      func.should_receive(:call)

      callbacks.call(runner, :a)
    end
  end

  describe '#call' do
    it 'accepts unknown triggers' do
      callbacks = described_class.new

      expect do
        callbacks.call(runner, :unknown)
      end.not_to raise_error
    end

    it 'returns self' do
      callbacks = described_class.new

      callbacks.call(runner, :unknown).should eq callbacks
    end

    it 'passes callbacks and their arguments to a runner' do
      func = proc {}
      callbacks = described_class.new.
          on(:a, func)

      runner.should_receive(:run_state_machine_callback).with(func, 1, 2, 3)

      callbacks.call(runner, :a, 1, 2, 3)
    end

    it 'passes any arguments to the callback' do
      func = proc {}
      callbacks = described_class.new.
          on(:a, func)

      func.should_receive(:call).with(1, 2, 3)

      callbacks.call(runner, :a, 1, 2, 3)
    end

    it 'calls the :any callbacks for every trigger' do
      func = proc {}
      callbacks = described_class.new.
          on(:any, func).
          on(:a, func)

      func.should_receive(:call).with(1, 2, 3).twice

      callbacks.call(runner, :a, 1, 2, 3)
    end

    it 'does not accept the :any trigger' do
      callbacks = described_class.new

      expect do
        callbacks.call(runner, :any)
      end.to raise_error ComposableStateMachine::InvalidTrigger
    end
  end

end
