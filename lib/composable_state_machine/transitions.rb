module ComposableStateMachine

  # Defines the transitions a state machine can make.
  class Transitions
    # Creates a {Transitions} object.
    #
    # @note While nil is a valid state to transition from, it is not a valid state to transition to.
    #
    # @param (Hash<event, Hash<from_state, to_state>>) transitions transitions Hash mapping events to a Hash from -> to state transitions
    def initialize(transitions = {})
      @transitions_for = transitions
      validate_transitions
    end

    # Adds to the transitions for an event.
    #
    # @param [Object] event event causing the transition
    # @param [Hash<from_state, to_state>] transitions transitions to the added to the transitions for the event.
    #
    # @return [self] for chaining
    def on(event, transitions)
      (@transitions_for[event] ||= {}).tap do |transitions_for_event|
        transitions_for_event.merge!(transitions)
        validate_transitions_for_event(event, transitions_for_event)
      end
      self
    end

    # Checks the transition map for a valid transition from a state given an event
    #
    # @param [Object] state the state the machine is in
    # @param [Object] event event causing the transition
    #
    # @return [Object] new state for the machine, if a transition can occur
    # @return [nil] if a transition cannot happen with this event
    #
    # @raise [InvalidEvent] if an unknown event is provided
    def transition(state, event)
      transitions_for_event = @transitions_for[event]
      unless transitions_for_event
        raise InvalidEvent.new("invalid event", event, state)
      end
      transitions_for_event[state]
    end

    # @return [Array<Object>] events for the machine
    def events
      @transitions_for.keys
    end

    # @return [Array<Object>] the states of the machine
    def states
      events.map { |e| @transitions_for[e].to_a }.flatten.uniq
    end

    private

    def validate_transitions
      @transitions_for.each_pair do |event, transitions|
        validate_transitions_for_event(event, transitions)
      end
    end

    def validate_transitions_for_event(event, transitions)
      transitions.each_pair do |from, to|
        if to.nil?
          raise InvalidTransition.new("transition to nil from #{from.inspect} for #{event.inspect} event")
        end
      end
    end
  end

end
