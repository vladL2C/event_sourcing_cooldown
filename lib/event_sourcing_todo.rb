require "securerandom"
require "cli/ui"
require "terminal-table"

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
Dir[File.join(__dir__, "**", "*.rb")].each { |file| require file }

class EventSourcingTodo
  def initialize
    @model = ViewModel::App.new
  end

  def handle(selection)
    case selection
    when "Create new todo"
      model.handle_create
    when "Update todo description"
      model.handle_update
    when "Mark todo as completed"
      model.handle_complete
    when "Uncomitted changes"
      model.handle_uncommitted_changes
    when "Commit changes"
      model.handle_commit_changes
    end
  end

  def state
    model.state
  end

  private

  attr_reader :model
end
