module ComposableStateMachine

  # Manages callbacks for a behavior.
  class Callbacks
    # Creates a {Callbacks} object.
    #
    # @param [Hash<trigger, callback(s)>] callbacks maps triggers to zero or more callbacks.
    def initialize(callbacks = {})
      @callbacks = Hash.new { |hash, key| hash[key] = [] }
      callbacks.each_pair do |trigger, proc|
        if proc.respond_to?(:each)
          proc.each do |callback|
            on(trigger, callback)
          end
        else
          on(trigger, proc)
        end
      end
    end

    # Adds a callback for a trigger.
    #
    # @param [Object] trigger the callback trigger
    # @param [Proc, Method, ...] proc an object responding to #call. If non-nil, it will be given precedence to #block
    # @param [block] block an optional block implementing the callback
    #
    # @return [self] for chaining
    def on(trigger, proc = nil, &block)
      @callbacks[trigger] << (proc || block)
      self
    end

    # Runs the callbacks for a trigger with a runner.
    #
    # Runs the callbacks for the :any trigger for every trigger.
    #
    # @param [Object] runner the runner
    # @param [Object] trigger the callback trigger
    # @param [Array<Object>] args parameters to pass to the callbacks' #call methods.
    #
    # @return [self] for chaining
    def call(runner, trigger, *args)
      if trigger == :any
        raise InvalidTrigger.new(':any is not a valid trigger')
      end
      @callbacks[trigger].each do |callback|
        runner.run_state_machine_callback(callback, *args)
      end
      @callbacks[:any].each do |callback|
        runner.run_state_machine_callback(callback, *args)
      end
      self
    end
  end

end
