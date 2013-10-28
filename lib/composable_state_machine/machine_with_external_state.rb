module ComposableStateMachine

  # State machine instance that manages its state via a reader and writer objects.
  class MachineWithExternalState
    # Creates an instance.
    #
    # @param [Model, ...] model the model for the machine
    # @param [Proc, Method, ...] state_reader object whose #call method will return the current state
    # @param [Proc, Method, ...] state_writer object whose #call method will be called with the new state after a transition
    # @param [Hash] options the options to create the machine with.
    # @option options [Object] :state (model#initial_state) State of the machine.
    # @option options [Object] :callback_runner (model#callback_runner) Object whose #run_state_machine_callback method will be used to execute behavior callbacks.
    def initialize(model, state_reader, state_writer, options = {})
      @model = model
      @state_reader = state_reader
      @state_writer = state_writer
      @callback_runner = options[:callback_runner] || model.callback_runner
      initial_state = options[:state] || model.initial_state
      @state_writer.call(initial_state)
    end

    # Executes the transition and behaviors associated with an event.
    #
    # @param [Object] event the event
    # @param [Array<Object>] args event arguments
    #
    # @return [Object, nil] the result of model#transition
    def trigger(event, *args)
      current_state = @state_reader.call
      @model.transition(current_state, event, args, @callback_runner, &@state_writer)
    end

    # Checks whether the state of the machine is equal to another state
    #
    # @return [TrueClass, FalseClass]
    def ==(other_state)
      @state_reader.call == other_state
    end
  end

end
