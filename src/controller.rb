=begin

    File: controller.rb
    Author:
    Date Created: 9/8/17
    Description: 

=end

require_relative "driver"

class Controller

    def initialize
        @drive = Driver.new
    end

    def run


        @drive.title_print("Event Coordinator")

        menu = Array.new

        menu[0] = "1. Admin Mode"
        menu[1] = "2. User Mode"
        
        menu_choice = @drive.menu_builder(menu)

        case menu_choice
            when 1
                puts "option 1"
            when 2
                puts "option 2"
        end


    end

end