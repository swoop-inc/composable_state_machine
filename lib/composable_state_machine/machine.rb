require_relative 'machine_with_external_state'

module ComposableStateMachine

  # Machine with its own state.
  class Machine < MachineWithExternalState
    attr_reader :state

    # Creates a machine. Delegates to {MachineWithExternalState#initialize} passing method(:state) & method(:state=) as the state reader and writer.
    def initialize(model, options = {})
      super(model, method(:state), method(:state=), options)
    end

    private

    def state=(new_state)
      @state = new_state
    end
  end

end
