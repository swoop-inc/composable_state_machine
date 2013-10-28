module ComposableStateMachine

  # Raised when an invalid event is passed into {Transitions#transition}.
  class InvalidEvent < NoMethodError
  end

end
