module  Events
  class TodoCompleted
    attr_reader :completed

    def initialize
      @completed = true
    end
  end
end
