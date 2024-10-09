module EventStore
  class MemoryRepo
    attr_reader :store

    def initialize
      @store = Hash.new{|k,v| k[v] = []}
    end

    def get(aggregate)
      load_events(aggregate)
    end

    def save(aggregate)
      commit(aggregate)
    end

    private
    def load_events(aggregate)
      events = @store[aggregate.id]
      events.each {|e| aggregate.apply(e)}
      aggregate
    end

    def commit(aggregate)
      @store[aggregate.id] = aggregate.changes
      aggregate.clear_changes
    end
  end
end
