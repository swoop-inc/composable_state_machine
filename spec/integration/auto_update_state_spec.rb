require 'spec_helper'

describe 'automatic state updates' do

  class Room
    MACHINE_MODEL = ComposableStateMachine.model(
        transitions: {
            heat: {cold: :warm, warm: :hot},
            cool: {warm: :cold, hot: :warm},
        }
    )

    attr_accessor :temp

    def initialize(temp)
      @machine = ComposableStateMachine::MachineWithExternalState.new(
          MACHINE_MODEL, method(:temp), method(:temp=), state: temp)
    end

    def heat(periods = 1)
      periods.times { @machine.trigger(:heat) }
    end

    def cool(periods = 1)
      periods.times { @machine.trigger(:cool) }
    end
  end

  it 'updates the room temperature automatically' do
    Room.new(:cold).tap do |room|
      room.heat(5)
      room.temp.should eq :hot
      room.cool
      room.temp.should eq :warm
    end
  end

end
