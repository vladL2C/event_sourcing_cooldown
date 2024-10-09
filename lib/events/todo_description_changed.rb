module  Events
  class TodoDescriptionChanged
    attr_reader :description

    def initialize(description:)
      @description = description
    end
  end
end
