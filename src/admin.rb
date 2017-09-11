=begin

    File: admin.rb
    Author:
    Date Created: 9/8/17
    Description:

=end

require_relative "driver"
require 'date'

class Admin

        def initialize
          @fName = " "
          @lName = " "
          @drive = Driver.new
          @military_time = true;
          @event_date = Date.new
          @event_date_time = DateTime.new
        end

        def run
          @drive.title_print("Admin Mode")
          print set_admin_info
          print create_event
        end

        #Accessor method
        def get_f_name
          @fName
        end

        def get_l_name
          @lName
        end

        def get_event_date
          @event_date
        end

        def get_event_date_time
          @event_date_time
        end

        #Setter method
        def set_f_name(theFName)
          @fName = theFName;
        end

        def set_l_name(theLName)
          @lName = theLName
        end

        def set_event_date(date)
          @event_date = date
        end

        def set_event_date_time(date_time)
          @event_date_time = date_time
        end

        #Receive admin's information
        def set_admin_info
          print "Enter your First Name: "
          firstName = gets.chomp

          #Using Regexp class
          while !(firstName =~ /[[:alpha:]]/)
            print "Not a valid input. Enter your First Name: "
            firstName = gets.chomp
          end

          print "Enter your Last Name: "
          lastName = gets.chomp

          #Using Regexp class
          while !(lastName =~ /[[:alpha:]]/)
            print "Not a valid input. Enter your Last Name: "
            lastName = gets.chomp
          end

          set_f_name(firstName)
          set_l_name(lastName)
        end

        #Method in charge of getting information of events and creating them.
        def create_event
          invalid_date = true

          #Temperary date of todays date.
          date = Date.today

            @drive.title_print("Create an Event")

            print "Enter a name for the event: "
            eventName = gets.chomp

            print "Give a description of the event: "
            eventDescription = gets.chomp

          while invalid_date
            #Retrieves the event's year from the user.                          Event's Year.
            print "Input the year you'd like to make the event for: "
            event_year = gets.chomp
            while !(event_year =~ /[[:digit:]]/)
              print "Invalid input, please enter a year"
              eventy_year = gets.chomp
            end

            while (event_year < date.year.to_s) || (event_year > "2100")
              print "Invalid year, please input a reasonable year: "
              event_year = gets.chomp
            end

            #Creates array of months for user to select from for events months
            monthMenu = Array.new

            monthMenu[0] = "1. January"
            monthMenu[1] = "2. February"
            monthMenu[2] = "3. March"
            monthMenu[3] = "4. April"
            monthMenu[4] = "5. May"
            monthMenu[5] = "6. June"
            monthMenu[6] = "7. July"
            monthMenu[7] = "8. August"
            monthMenu[8] = "9. September"
            monthMenu[9] = "10. October"
            monthMenu[10] = "11. November"
            monthMenu[11] = "12. December"

            #Takes the user's choice and uses a temp variable for event's month.Event's month.
            puts "Please choose a month for the event: "
            month_choice = @drive.menu_builder(monthMenu)
            while (month_choice < 1) || (month_choice > 12)
              month_choice = gets.chomp
            end

            #Creates a new array based on the days of the month. Range (1-31)
            dayMenu = Array.new
            for i in 0...31
              dayMenu[i] = i + 1
            end

            #Takes the user's choice and uses a temp variable for event's day.  Event's day.
            puts "Please choose a day for the event: "
            day_choice = @drive.menu_builder(dayMenu)
            while (day_choice < 1) || (day_choice > 31)
              day_choice = gets.chomp
            end

            #Verifies if the date is a valid date for the event.
            if !(Date.valid_date?(event_year.to_i, month_choice.to_i, day_choice.to_i))
              invalid_date = true
              puts "Date is not valid."
            else
              d = Date.new(event_year.to_i, month_choice.to_i, day_choice.to_i)
              set_event_date(d)
              invalid_date = false
            end



          end




        end

    end
