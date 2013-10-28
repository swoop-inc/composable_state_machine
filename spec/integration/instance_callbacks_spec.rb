require 'spec_helper'

describe 'callbacks binding to class instances' do

  class Person1
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
            }
        }
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
    STDOUT.should_receive(:puts).with('Welcome, Bob!')
    STDOUT.should_receive(:puts).with('Gee, Bob...')

    Person1.new('Bob', :candidate).hire!.fire!
  end

end
