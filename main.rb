=begin

    File: main.rb
    Author: Abraham Dick
    Date Created: 9/8/17
    Description: In charge of running the program from the top level folder (creating the main controller)

=end

require "./src/controller.rb"
require "./src/event.rb"

def run
    system "clear"
    co = Controller.new

    co.run
end

run
