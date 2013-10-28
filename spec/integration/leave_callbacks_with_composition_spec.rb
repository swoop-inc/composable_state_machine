require 'spec_helper'

describe 'extending state machines with leave callbacks through composition' do

  class ComposableModelWithLeaveCallbacks
    delegate :initial_state, :callback_runner, to: :@model

    def initialize(*args)
      @model = ComposableStateMachine::Model.new(*args)
    end

    def transition(current_state, event, arguments = [], callback_runner = nil)
      @model.transition(current_state, event, arguments, callback_runner) do |new_state|
        @model.run_callbacks_for(callback_runner, :leave, current_state,
                                 current_state, event, new_state, *arguments)
        yield new_state if block_given?
      end
    end
  end

  class Person3
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
        model_factory: ComposableModelWithLeaveCallbacks
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

    Person3.new('Bob', :candidate).hire!.fire!.hire!
  end

end
