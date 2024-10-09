module ViewModel
  class App
    attr_reader :repo, :state

    def initialize
      @state = []
      @repo = EventStore::MemoryRepo.new
    end

    def handle_create
      perform_create { |aggregate, description| aggregate.apply(Events::TodoAdded.new(description: description)) }
    end

    def handle_update
      perform do |aggregate|
        description = CLI::UI.ask("What did you want to change the description to?")
        aggregate.apply(Events::TodoDescriptionChanged.new(description: description))
      end
    end

    def handle_complete
      perform do |aggregate|
        aggregate.apply(Events::TodoCompleted.new)
      end
    end

    def handle_uncommitted_changes
      draw_table(
        "Uncomitted changes",
        ["Id", "Description", "Completed", "Changes"],
        state.map { |a| [a.id, a.description, a.completed, a.changes.length] }
      )
    end

    def handle_commit_changes
      state.each { |a| repo.save(a) }
      state.clear
      draw_table(
        "Comitted changes",
        ["Id", "Events"],
        @repo.store.map { |k, v| [k, v.length] }
      )
    end

    private

    attr_writer :state

    def perform_create
      aggregate = Aggregates::Todo.new(SecureRandom.uuid)
      description = CLI::UI.ask("What do you need to do?")
      yield(aggregate, description)
      state << aggregate
    end

    def perform
      aggregate_id = CLI::UI.ask("Pick an aggregate to update", options: options)
      aggregate = get(aggregate_id)
      yield(aggregate)
    end

    def options
      state.map(&:id)
    end

    def get(aggregate_id)
      state.find { |a| a.id == aggregate_id }
    end

    def draw_table(title, headings, rows)
      table = Terminal::Table.new do |t|
        t.title = title
        t.style = {border: :unicode_round}
        t.headings = headings
        t.rows = rows
        t.align_column(1, :right)
        t.align_column(2, :right)
      end
      puts table
    end
  end
end
