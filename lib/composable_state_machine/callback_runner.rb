module ComposableStateMachine

  # Mixin module that runs callbacks with self pointing to the object the module is included in.
  module CallbackRunner
    # Runs a callback with self pointing to the object the module is included in.
    #
    # @param [Proc, Method, UnboundMethod, ...] callback the callback. Unbound methods will be bound to the object the mixin is included in.
    # @param [Array<Object>] args parameters to pass to the callback.
    #
    # @return [Object] the result of the callback
    def run_state_machine_callback(callback, *args)
      if callback.respond_to?(:bind)
        callback = callback.bind(self)
      end
      instance_exec(*args, &callback)
    end
  end

end
