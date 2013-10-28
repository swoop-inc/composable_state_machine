module ComposableStateMachine

  # Defines the behaviors of a state machine.
  class Behaviors
    # Creates a {Behaviors} object.
    #
    # @param [Hash<behavior, Hash<trigger, callback>>] behaviors triggers and callbacks per behavior. The triggers and callbacks can be provided as an object the responds to #call or they can be provided as a Hash<trigger, callback>. In the latter case, the callbacks factory will be used to create an object that would manage the callbacks for the behavior.
    # @param [Object] callbacks_factory object whose #new method will be called with a Hash<trigger, callback>.
    def initialize(behaviors = {}, callbacks_factory = Callbacks)
      @callbacks_factory = callbacks_factory
      @behaviors = behaviors.reduce({}) do |memo, (behavior, value)|
        handler = value.respond_to?(:call) ? value : @callbacks_factory.new(value)
        memo[behavior] = handler
        memo
      end
    end

    # Adds callbacks for a behavior.
    #
    # Selects the callback manager for the behavior and forwards to its #on method.
    #
    # @param [Object] behavior the behavior
    # @param [Array<Object>] args parameters to pass to the callback manager's #on method.
    #
    # @return [self] for chaining
    def on(behavior, *args, &block)
      (@behaviors[behavior] ||= @callbacks_factory.new).on(*args, &block)
      self
    end

    # Runs callbacks for a behavior with a runner.
    #
    # Selects the callback manager for the behavior and forwards to its #call method.
    #
    # @param [Object] runner the runner
    # @param [Object] behavior the behavior
    # @param [Array<Object>] args parameters to pass to the callback manager's #call method.
    #
    # @return [self] for chaining
    def call(runner, behavior, *args)
      @behaviors[behavior].tap do |handler|
        handler.call(runner, *args) if handler
      end
      self
    end
  end

end
