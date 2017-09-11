=begin

    File: controller.rb
    Author:
    Date Created: 9/8/17
    Description:

=end

require_relative "driver"
require_relative "admin"
require_relative "user"
require_relative "event"
require_relative "databaseController"

class Controller

    def initialize
        @drive = Driver.new
    end

    def run

        @drive.title_print("Event Coordinator")

        print "\n\n"
        puts "\t            \u2513"
        puts "\t          \u2571"
        puts "\t        ╱           | EECS 448 Project 1"
        puts "\t      ╳             | Team: Git Schwifty"
        puts "\t    ╱               | Alex, Abe, Qualen"
        puts "\t  ╱"
        puts "\t\u2516\n\n\n"

        menu = Array.new

        menu[0] = "1. Admin Mode"
        menu[1] = "2. User Mode"
        menu[2] = "3. Quit"
         
        menu_choice = @drive.menu_builder(menu)

        case menu_choice
            when 1
                @admin_controller = Admin.new
                @admin_controller.run
            when 2
                @user_controller = User.new
                @user_controller.run
        end
		
    end

end
