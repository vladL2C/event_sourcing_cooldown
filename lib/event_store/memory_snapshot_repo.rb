module EventStore
  class MemorySnapshotRepo
    def initialize
      @store = {}
    end

    def shoot(aggregate)
      @store[aggregate.id] = aggregate
    end

    def get(aggregate)
      @store[aggregate.id]
    end
  end
end
