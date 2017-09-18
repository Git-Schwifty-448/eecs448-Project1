=begin

    File: controller.rb
    Author: Abraham Dick
    Date Created: 9/8/17
    Description: Controls the basic distribution between the two main modes and looping

=end

require_relative "driver"
require_relative "admin"
require_relative "attend"
require_relative "event"
require_relative "attendee"
require_relative "databaseController"

class Controller

    def initialize
        @drive = Driver.new
    end

    def run
        # Create objects for both modes to keep military time constant
        @admin_controller = Admin.new
        @user_controller = Attend.new

        while true
            system 'clear'
            @drive.title_print("Quablex Event Coordinator")

            print "\n\n"
            puts "\t            \u2513"
            puts "\t          \u2571"
            puts "\t        ╱           | EECS 448 Project 1"
            puts "\t      ╳             | Team: Git Schwifty"
            puts "\t    ╱               | Alex, Abe, Qualen"
            puts "\t  ╱"
            puts "\t\u2516\n\n\n"

            menu = Array.new
            menu[0] = "1. Create Events (Admin Mode)"
            menu[1] = "2. Go to Events (Adding Availability Mode)"
            menu[2] = "3. Quit"
            menu_choice = @drive.menu_builder(menu)

            case menu_choice
                when 1
                    @admin_controller.run
                when 2
                    @user_controller.run
                when 3
                    break
            end

        end
    end
end