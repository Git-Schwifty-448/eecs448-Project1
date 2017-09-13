=begin

    File: main.rb
    Author:
    Date Created: 9/8/17
    Description:

=end

require "./src/controller.rb"
require "./src/event.rb"

def run
    system "clear"
    co = Controller.new

    co.run
end

run
