=begin

    File: controller.rb
    Author:
    Date Created: 9/8/17
    Description: 

=end

require_relative "driver"
require_relative "admin"
require_relative "user"

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
                @admin_controller = Admin.new
                @admin_controller.run
            when 2
                @user_controller = User.new
                @user_controller.run
        end


    end

end