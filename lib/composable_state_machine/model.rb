module ComposableStateMachine

  # An immutable state machine model that can be shared across many instances.
  class Model
    attr_reader :initial_state
    attr_reader :callback_runner

    # Creates a state machine model.
    #
    # @param [Hash] options the options to create a model with.
    # @option options [Hash, Transitions] :transitions State machine transitions. A {Transitions} object will be created if a Hash is provided.
    # @option options [Hash, Behaviors] :behaviors State machine behaviors. A {Behaviors} object will be created if a Hash is provided. If omitted, a high-performance behaviors stub will be used.
    # @option options [Object] :initial_state (nil) Default initial state for the machine. This can be overriden by a machine instance.
    # @option options [Object] :callback_runner (DefaultCallbackRunner) Object whose #run_state_machine_callback method will be used to execute behavior callbacks. {DefaultCallbackRunner} simply calls a Proc's #call method.
    def initialize(options = {})
      @initial_state = options[:initial_state]
      @transitions = options[:transitions]
      @behaviors = options[:behaviors] || proc {}
      @callback_runner = options[:callback_runner] || DefaultCallbackRunner
    end

    # Performs a transition of the machine, executing behaviors as needed.
    #
    # @param current_state [Object] the current state of the machine
    # @param event [Object] the event the machine has received
    # @param arguments [Enumerable] ([]) any arguments related to the event.
    # @param callback_runner [Object] ({Model#callback_runner}) the runner with which to execute callbacks
    #
    # @yield [Object] the new state of the machine, if a transition happened
    #
    # @return [Object] the new state of the machine, if a transition happened
    # @return [nil] if no transition happened
    def transition(current_state, event, arguments = [], callback_runner = nil)
      @transitions.transition(current_state, event).tap do |new_state|
        if new_state && new_state != current_state
          callback_runner ||= @callback_runner
          run_callbacks(callback_runner, current_state, event, new_state, arguments)
          yield new_state if block_given?
        end
      end
    end

    # Runs the callbacks for all behaviors for a state transition
    def run_callbacks(callback_runner, current_state, event, new_state, arguments, &block)
      run_callbacks_for(callback_runner, :enter, new_state,
                        current_state, event, new_state, *arguments)
    end

    # Runs the callbacks for one behavior for a start transition
    def run_callbacks_for(callback_runner, behavior, *args)
      @behaviors.call(callback_runner, behavior, *args)
    end
  end

end
