=begin

    File: main.rb
    Author:
    Date Created: 9/8/17
    Description:

=end

require "./src/controller.rb"
require "./src/event.rb"
require "./src/databaseController.rb"

def run
    puts "Run"

    co = Controller.new

    co.run

	dbCont = DatabaseController.new
	e = Event.new("Partaaay", "gonna be lit", "6", "whenever")
	dbCont.persist_event(e)
end

run
