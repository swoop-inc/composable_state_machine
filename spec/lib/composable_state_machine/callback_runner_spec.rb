require 'spec_helper'

describe ComposableStateMachine::CallbackRunner do

  context 'with callables' do
    class TestClass
      include ComposableStateMachine::CallbackRunner

      def initialize(name)
        @name = name
        @callback = lambda { |greeting| "#{greeting}, #{@name}!" }
      end

      def test_callback(greeting)
        run_state_machine_callback(@callback, greeting)
      end
    end

    it 'runs callbacks in the context of the object' do
      obj = TestClass.new('Bob')

      obj.test_callback('Hello').should eq 'Hello, Bob!'
    end
  end

  context 'with unbound methods' do
    class TestClass
      include ComposableStateMachine::CallbackRunner

      def initialize(name)
        @name = name
      end

      def test_callback(greeting)
        run_state_machine_callback(CALLBACK_METHOD, greeting)
      end

      private

      def greet(greeting)
        "#{greeting}, #{@name}!"
      end

      CALLBACK_METHOD = instance_method(:greet)
    end

    it 'runs callbacks in the context of the object' do
      obj = TestClass.new('Bob')

      obj.test_callback('Hello').should eq 'Hello, Bob!'
    end
  end

end
