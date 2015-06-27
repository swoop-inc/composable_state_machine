Gem.find_files("composable_state_machine/**/*.rb").each { |path| require path }
# @author {https://github.com/ssimeonov Simeon Simeonov}, {http://swoop.com Swoop, Inc.}
#
# For examples, see the {file:README.html README}.
module ComposableStateMachine

  # Creates a state machine model.
  #
  # State machine models are immutable and can be shared across many state machine instances.
  #
  # @param [Hash] options the options to create a model with.
  # @option options [Hash, Transitions] :transitions State machine transitions. A {Transitions} object will be created if a Hash is provided.
  # @option options [Hash, Behaviors] :behaviors State machine behaviors. A {Behaviors} object will be created if a Hash is provided. If omitted, a high-performance behaviors stub will be used.
  # @option options [Object] :callback_runner (DefaultCallbackRunner) Object whose #run_state_machine_callback method will be used to execute behavior callbacks. {DefaultCallbackRunner} simply calls a Proc's #call method.
  # @option options [Object] :initial_state (nil) Default initial state for the machine. This can be overriden by a machine instance.
  # @option options [Object] :model_factory (Model) The object whose #new method will be called to create a model.
  def self.model(options)
    options = options.dup
    unless options[:transitions].respond_to?(:transition)
      options[:transitions] = Transitions.new(options[:transitions] || {})
    end
    unless options[:behaviors].respond_to?(:call)
      options[:behaviors] = Behaviors.new(options[:behaviors] || {})
    end
    (options[:model_factory] || Model).new(options)
  end

  # Creates a state machine from a model.
  #
  # The variable number of arguments is driven by the difference in initialization APIs between different machines.
  #
  # The last argument must be an options Hash. It may have at least the following options:
  #
  # - :callback_runner [Object] (DefaultCallbackRunner) Object whose #run_state_machine_callback method will be used to execute behavior callbacks. {DefaultCallbackRunner} simply calls a Proc's #call method. When you want to execute callbacks in the context of an object, include the {CallbackRunner} mixin in the object and then pass the object as the callback runner here.
  # - :state [Object] (model#initial_state) State the machine is in.
  # - :model_factory [Object] ({Machine}) The object whose #new method will be called to create the machine.
  #
  # @param [Model, ...] model the state machine model.
  # @param [any] args additional arguments passed to the model.
  def self.machine(model, *args)
    options = args.last
    (options[:machine_factory] || Machine).new(model, *args)
  end
end
