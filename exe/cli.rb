require "cli/ui"
require_relative "../lib/event_sourcing_todo"

class Cli
  def self.start
    todo = EventSourcingTodo.new
    CLI::UI::StdoutRouter.enable
    loop do
      choice = CLI::UI::Prompt.ask("Select an option") do |handler|
        handler.option("Create new todo") { |selection| todo.handle(selection) }
        handler.option("Update todo description") { |selection| todo.handle(selection) } unless todo.state.empty?
        handler.option("Mark todo as completed") { |selection| todo.handle(selection) } unless todo.state.empty?
        handler.option("Uncomitted changes") { |selection| todo.handle(selection) } unless todo.state.empty?
        handler.option("Commit changes") { |selection| todo.handle(selection) } unless todo.state.empty?
        handler.option("exit") { Process.exit }
      end
    end
  end
end

Cli.start
