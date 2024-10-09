module  Events
  class TodoAdded
    attr_reader :description, :completed

    def initialize(description:)
      @description = description
      @completed = false
    end
  end
end
