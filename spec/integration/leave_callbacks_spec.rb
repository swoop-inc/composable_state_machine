require 'spec_helper'

describe 'extending state machines with leave callbacks' do

  class ModelWithLeaveCallbacks < ComposableStateMachine::Model
    def run_callbacks(callback_runner, current_state, event, new_state, arguments)
      run_callbacks_for(callback_runner, :leave, current_state,
                        current_state, event, new_state, *arguments)
      super
    end
  end

  class Person2
    include ComposableStateMachine::CallbackRunner

    MACHINE_MODEL = ComposableStateMachine.model(
        transitions: {
            hire: {candidate: :hired, departed: :hired, fired: :hired},
            leave: {hired: :departed},
            fire: {hired: :fired},
        },
        behaviors: {
            enter: {
                hired: proc { puts "Welcome, #{@name}!" },
                fired: proc { puts "Gee, #{@name}..." },
            },
            leave: {
                fired: proc { puts 'Is this a good idea?' }
            }
        },
        model_factory: ModelWithLeaveCallbacks
    )

    def initialize(name, state)
      @name = name
      @machine = ComposableStateMachine.machine(
          MACHINE_MODEL,
          state: state, callback_runner: self)
    end

    def hire!
      @machine.trigger(:hire)
      self
    end

    def fire!
      @machine.trigger(:fire)
      self
    end
  end

  it 'runs callbacks in the context of the Person instance' do
    STDOUT.should_receive(:puts).with('Welcome, Bob!').twice
    STDOUT.should_receive(:puts).with('Gee, Bob...')
    STDOUT.should_receive(:puts).with('Is this a good idea?')

    Person2.new('Bob', :candidate).hire!.fire!.hire!
  end

end
