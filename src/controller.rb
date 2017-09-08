=begin

    File: controller.rb
    Author:
    Date Created: 9/8/17
    Description: 

=end

require_relative "driver"

class Controller

    def initialize
    end

    def original
        drive = Driver.new

        drive.title_print("Hello from Controller")
    end

end