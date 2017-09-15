=begin

    File: admin.rb
    Author: Qualen Pollard
    Date Created: 9/8/17
    Description: Models the admins controls over creating events.

=end

require_relative "driver"
require_relative "attendee"
require_relative "databasecontroller"
require 'date'

class Admin

        def initialize
          @fName = " "
          @lName = " "
          @event_counter = 0
          @event_name = " "
          @description = " "
          @drive = Driver.new
          @military_time = true;
          @event_date = Date.new
          @timeslots_array = Array.new
          @DB = DatabaseController.new
          @hour_counter = 0
        end

        def run                                                                 #Main method that calls other methods
          yesNo = true
          @drive.title_print("Admin Mode")
          set_admin_info

          while yesNo
            create_date
            create_date_time(get_event_counter)

            #Creation of new attendee
            #admin_name = get_f_name + get_l_name
            #admin_attendee = Attendee.new(admin_name, get_timeslots_array)

            #Temp array for the attendee array for the event
            #attendee_array = Array.new
            #attendee_array[0] = admin_attendee

            #Creation of the event.
            #event = Event.new(get_event_name, get_description, get_event_date, get_timeslots_array, attendee_array)
            #@DB.persist_event(event)

            set_event_counter(1)
            yesNo = get_validation                                              #Asks user if they want to create another event.
          end

        end

        #Accessor method
        def get_f_name
          @fName
        end

        def get_l_name
          @lName
        end

        def get_event_counter
          @event_counter
        end

        def get_event_name
          @event_name
        end

        def get_description
          @description
        end

        def get_event_date
          @event_date
        end

        def get_timeslots_array
          @timeslots_array
        end

        #Setter method
        def set_f_name(theFName)
          @fName = theFName;
        end

        def set_l_name(theLName)
          @lName = theLName
        end

        def set_event_counter(increase_number)
          @event_counter += increase_number
        end

        def set_event_name(event_name)
          @event_name = event_name
        end

        def set_event_description(event_description)
          @description = event_description
        end

        def set_event_date(date)
          @event_date = date
        end

        def set_timeslot_array(timeslots, i)
          @timeslots_array[i] = timeslots[i]

        end

        #Receive admin's information
        def set_admin_info                                                      #Getting admin's info.
          print "Enter your First Name: "
          firstName = STDIN.gets.chomp

          #Using Regexp class
          while !(firstName =~ /[[:alpha:]]/)
            print "Not a valid input. Enter your First Name: "
            firstName = STDIN.gets.chomp
          end

          print "Enter your Last Name: "
          lastName = STDIN.gets.chomp

          #Using Regexp class
          while !(lastName =~ /[[:alpha:]]/)
            print "Not a valid input. Enter your Last Name: "
            lastName = STDIN.gets.chomp
          end

          set_f_name(firstName)
          set_l_name(lastName)
        end

        #Method in charge of getting information of events and creating them.
        def create_date                                                         #Creation of date.
          invalid_date = true

          #Temperary date of todays date.
          date = Date.today

            @drive.title_print("Date Formation")

            print "Enter a name for the event: "
            eventName = STDIN.gets.chomp
            set_event_name(eventName)

            print "Give a description of the event: "
            eventDescription = STDIN.gets.chomp
            set_event_description(eventDescription)

          while invalid_date
            #Retrieves the event's year from the user.                          Event's Year.
            print "Input the year you'd like to make the event for(YYYY): "
            event_year = STDIN.gets.chomp
            while !(event_year =~ /[[:digit:]]/)
              print "Invalid input, please enter a year: "
              eventy_year = STDIN.gets.chomp
            end

            while (event_year < date.year.to_s) || (event_year > "2100")
              print "Invalid year, please input a reasonable year: "
              event_year = STDIN.gets.chomp
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
              month_choice = STDIN.gets.chomp
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
              day_choice = STDIN.gets.chomp
            end

            #Verifies if the date is a valid date for the event.
            if !(Date.valid_date?(event_year.to_i, month_choice.to_i, day_choice.to_i))
              invalid_date = true
              puts "Date is not valid."
            else
              d = Date.new(event_year.to_i, month_choice.to_i, day_choice.to_i)
              if d < Date.today
                invalid_date = true
                puts "Date is not valid."
              else
                set_event_date(d)
                invalid_date = false
              end
            end

          end

        end


        def create_date_time(event_number)                                      #Creation of time.
          @drive.title_print("Time setup")
          start_time_match = true

          print "(12hr) or (24hr)?: "
          hour_rep = STDIN.gets.chomp
          while (hour_rep.casecmp("12") != 0) && (hour_rep.casecmp("24") != 0)
            print "I'm sorry, please enter either 12 or 24: "
            hour_ rep = STDIN.gets.chomp
          end

          temp_array = create_time_array(hour_rep)

          if hour_rep == "12"

            puts "How many time slots would you like to take for this event? \n"
            print "(30 min increments):"
            time_amount = STDIN.gets.chomp

            slot_choices = Array.new
            for(int i = 0; i < 48; i++)
              slot_choices = (i + 1)
            end
            
            while time_amount.casecmp("48") || time_amount.casecmp
              print "That's not a valid amount of slots, input a reasonable amount(1-48): "
              time_amount = STDIN.gets.chomp
            end

            #Retreives the start time from the user.
            print "Enter a start time (i.e., ):"
            start_time = STDIN.gets.chomp

            #Checks to see if the time is valid throughout the array.
            start_time_match = time_check(start_time, temp_array)
            while start_time_match
              print "Must enter a valid time: "
              start_time = STDIN.gets.chomp
              start_time_match = time_check(start_time, temp_array)
            end

            #Retreives the end time from the user.
            print "Enter an end time (i.e., 8:30 P.M.): "
            end_time = STDIN.gets.chomp

            end_time_match = time_check(end_time, temp_array)
            while end_time_match
              print "Must enter a valid time: "
              end_time = STDIN.gets.chomp
              end_time_match = time_check(end_time, temp_array)
            end

            #Checking to see if the start time is after the end time.
            while (end_time.casecmp(start_time) == -1)
              print "The end time can't be before the start time, try again: "
              end_time = STDIN.gets.chomp
            end
          elsif hour_rep == "24"
            #Retreives the start time from the user.
            print "Enter a start time (i.e., 07:30 A.M. or 19:30 P.M.):"
            start_time = STDIN.gets.chomp

            #Checks to see if the time is valid throughout the array.
            start_time_match = time_check(start_time, temp_array)
            while start_time_match
              print "Must enter a valid time: "
              start_time = STDIN.gets.chomp
              start_time_match = time_check(start_time, temp_array)
            end

            #Retreives the end time from the user.
            print "Enter an end time (i.e., 08:30 A.M. or 20:30 P.M.): "
            end_time = STDIN.gets.chomp

            end_time_match = time_check(end_time, temp_array)
            while end_time_match
              print "Must enter a valid time: "
              end_time = STDIN.gets.chomp
              end_time_match = time_check(end_time, temp_array)
            end

            #Checking to see if the start time is after the end time.
            while (end_time.casecmp(start_time) == -1)
              print "The end time can't be before the start time, try again: "
              end_time = STDIN.gets.chomp
            end
          end

          temp_array[get_event_counter] = start_time + "-" + end_time
          set_timeslot_array(temp_array, get_event_counter)

        end


        def get_validation
          print "Would you like to create another event?(Yes/No): "
          response = STDIN.gets.chomp

          #Check for Alphetical characters
          while !(response =~ /[[:alpha:]]/)
            print "Not a valid input. Enter Yes/No: "
            response = STDIN.gets.chomp
          end

          #Check for if the answer is yes or no.
          while (response.casecmp("yes") != 0) && (response.casecmp("no") != 0)
            print "Not a valid input. Enter Yes/No: "
            response = STDIN.gets.chomp
          end

          #Sets a temp variable to return to call.
          if ((response.casecmp("yes")) == 0)
            return true
          elsif ((response.casecmp("no")) == 0)
            return false
          end
        end

        #Creates an array based on the time representation that the user choses.
        def create_time_array(hr)
          if hr == "12"                                                   #12Hr time
            @hour_counter = 1

            #Creates an array with 12 hour time slots.
            twelve_hr_array = Array.new
            twelve_hr_array[0] = "12:00 A.M."
            twelve_hr_array[1] = "12:30 A.M."

            #Fills the array with the hourly time slots
            for i in 2...48
              if i % 2 == 0
                if i < 24
                  if i <= 19
                    twelve_hr_array[i] = (@hour_counter.to_s + ":00 A.M.")
                  elsif i > 19
                    twelve_hr_array[i] = (@hour_counter.to_s + ":00 A.M.")
                  end
                elsif i >= 24
                  twelve_hr_array[i] = (@hour_counter.to_s + ":00 P.M.")
                end
              elsif i % 2 == 1
                if i < 24
                  if i <= 19
                    twelve_hr_array[i] = (@hour_counter.to_s + ":30 A.M.")
                  elsif i > 19
                    twelve_hr_array[i] = (@hour_counter.to_s + ":30 A.M.")
                  end
                elsif i >= 24
                  twelve_hr_array[i] = (@hour_counter.to_s + ":30 P.M.")
                end
              end

              if i % 2 == 1
                @hour_counter += 1
              end

              #Resets hour_counter to 0 once it reaches 1 o'clock.
              if @hour_counter == 13
                @hour_counter = 1
              end
            end

            return twelve_hr_array
          elsif hr == "24"                                                #24Hr time
            @hour_counter = 0

            #Creates an array with 24 hour time slots.
            twentyfour_hr_array = Array.new

            #Fills the array with the hourly time slots
            for i in 0...48
              if i % 2 == 0
                if i < 24
                  if i <= 19
                    twentyfour_hr_array[i] = ("0" + @hour_counter.to_s + ":00 A.M.")
                  elsif i > 19
                    twentyfour_hr_array[i] = (@hour_counter.to_s + ":00 A.M.")
                  end
                elsif i >= 24
                  twentyfour_hr_array[i] = (@hour_counter.to_s + ":00 P.M.")
                end
              elsif i % 2 == 1
                if i < 24
                  if i <= 19
                    twentyfour_hr_array[i] = ("0" + @hour_counter.to_s + ":30 A.M.")
                  elsif i > 19
                    twentyfour_hr_array[i] = (@hour_counter.to_s + ":30 A.M.")
                  end
                elsif i >= 24
                  twentyfour_hr_array[i] = (@hour_counter.to_s + ":30 P.M.")
                end
              end

              if i % 2 == 1
                @hour_counter += 1
              end
            end

            return twentyfour_hr_array
          end
        end

        #Checks to see if the time matches any in the array.
        def time_check(time, array)
          for i in 0...48
            if time.casecmp(array[i]) == 0
              match = false
              break
            else
              match = true
            end
          end

          return match
        end

end
