module Aggregates
  class Todo
    attr_reader :id, :description, :completed

    def initialize(id)
      @changes = []

      @id = id
      @description = nil
      @completed = nil
    end

    def apply(event)
      case event
      when Events::TodoAdded
        apply_todo_added(event)
      when Events::TodoCompleted
        apply_todo_completed(event)
      when Events::TodoDescriptionChanged
        apply_todo_description_changed(event)
      end

      @changes << event
    end

    def clear_changes
      @changes = []
    end

    def changes
      @changes
    end

    private
    def apply_todo_added(event)
      @description = event.description
      @completed = event.completed
    end

    def apply_todo_completed(event)
      @completed = event.completed
    end

    def apply_todo_description_changed(event)
      @description = event.description
    end
  end
end
