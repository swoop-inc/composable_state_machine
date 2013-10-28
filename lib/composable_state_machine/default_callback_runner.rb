module ComposableStateMachine

  # Default callback runner that executes callbacks in their current binding.
  class DefaultCallbackRunner
    # Runs a callback in its current binding.
    #
    # @param [Proc, Method, ...] callback the callback, which must respond to #call.
    # @param [Array<Object>] args parameters to pass to the callback.
    #
    # @return [Object] the result of the callback
    def self.run_state_machine_callback(callback, *args)
      callback.call(*args)
    end
  end

end
