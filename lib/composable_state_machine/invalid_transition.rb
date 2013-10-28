module ComposableStateMachine

  # Raised in {Transitions} when nil is a state to transition to.
  class InvalidTransition < StandardError
  end

end
