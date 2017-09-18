=begin

    File: admin.rb
    Author: Qualen Pollard
    Date Created: 9/8/17
    Description: Models the admins controls over creating events.

=end

require_relative "driver"
require_relative "attendee"
require_relative "databaseController"
require 'date'

class Admin

        def initialize
            @fName = " "
            @lName = " "
            @event_counter = 0
            @event_name = " "
            @description = " "
            @events = true
            @military_time = true
            @drive = Driver.new
            @event_year = 0
            @event_month = 0
            @event_day = 0
            @event_hour = 0
            @event_minute = 0
            @timeslots_array = Array.new
            @DB = DatabaseController.new

            #-----------------------------------------
            @number_of_events = 0
            @spacer = "        "
            @attendee_created = false
            @attending_events = Array.new
        end

        def run                                                                 #Main method that calls other methods
            yesNo = true
            set_admin_info
            while yesNo

                menuone_choice = Array.new
                menuone_choice[0] = "1. Create Event"
                menuone_choice[1] = "2. See Attendees"


                system 'clear'
                @drive.title_print_ext("Admin Mode")
                @drive.sub_title_print("Options")
                puts "\n#{@spacer}Would you like to create an event or see attendees?(1 or 2): \n"
                atten_event = @drive.menu_builder_ext(menuone_choice)

                if atten_event == 1
                    create_date
                    create_date_time

                    #Creation of new attendee
                    admin_name = @fName + " " + @lName
                    admin_attendee = Attendee.new(admin_name, @timeslots_array)

                    #Temp array for the attendee array for the event
                    attendee_array = Array.new
                    attendee_array[0] = admin_attendee

                    #Creation of the event.
                    event = Event.new(@event_name, @description, @timeslots_array, attendee_array)
                    @DB.persist_event(event)

                    set_event_counter(1)
                    yesNo = get_validation                                              #Asks user if they want to create another event.
                elsif atten_event == 2
                    run2
                end
            end
        end

        #Accessor methods
        def get_event_counter
            @event_counter
        end

        #Setter methods
        def set_event_counter(increase_number)
            @event_counter += increase_number
        end

        #Pre: User chooses admin from homepage.
        #Post: An admin was created with firstName and lastName.
        #Return: None.
        def set_admin_info                                                      #Getting admin's info.
          system 'clear'
          @drive.title_print_ext("Admin Mode")
          @drive.sub_title_print("Get username")

          temp_name = ""
          temp_l_name = ""

            loop do
              print "\n\n#{@spacer}Please enter your first name: "
              temp_name = STDIN.gets.chomp

              if temp_name.match(/^[[:alpha:]]+$/)
                  break
              else
                  print "\n#{@spacer}Only letters are allowed in your first name."
              end

          end

          loop do
              print "\n\n#{@spacer}Please enter your last name: "
              temp_l_name = STDIN.gets.chomp

              if temp_l_name.match(/^[[:alpha:]]+$/)
                  break
              else
                  print "\n#{@spacer}Only letters are allowed in your last name."
              end

          end


            @fName = temp_name
            @lName = temp_l_name
        end

        #Pre: An admin was created.
        #Post: A Date object was created with the date of the event.
        #Return: None.
        def create_date                                                         #Creation of date.
            system 'clear'
            @drive.title_print_ext("Admin Mode")
            @drive.sub_title_print("Set Event Information")
            invalid_date = true

            #Temporary date of todays date.
            date = Date.today

            print "\n#{@spacer}Enter a name for the event: "
            eventName = STDIN.gets.chomp
            @event_name = eventName

            print "#{@spacer}Give a description of the event: "
            eventDescription = STDIN.gets.chomp
            @description = eventDescription

            while invalid_date
                #Retrieves the event's year from the user.                          Event's Year.
                print "\n#{@spacer}Input the year you'd like to make the event for(YYYY): "
                events_year = STDIN.gets.chomp
            while !(events_year =~ /[[:digit:]]/)
                print "\n#{@spacer}Invalid input, please enter a year: "
                events_year = STDIN.gets.chomp
            end

            while (events_year < date.year.to_s) || (events_year > "2100")
                print "#{@spacer}Invalid year, please input a reasonable year: "
                events_year = STDIN.gets.chomp
            end

            @event_year = events_year.to_i

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
            puts "\n#{@spacer}Please choose a month for the event(1-12): "
            month_choice = @drive.menu_builder_ext(monthMenu)
            while (month_choice < 1) || (month_choice > 12)
                month_choice = STDIN.gets.chomp
            end

            @event_month = month_choice.to_i

            case month_choice
            when 1
                print "#{@spacer}Remember there are 31 days in January."
            when 2
                print "#{@spacer}Remember there are 28 days in February."
            when 3
                print "#{@spacer}Remember there are 31 days in March."
            when 4
                print "#{@spacer}Remember there are 30 days in April."
            when 5
                print "#{@spacer}Remember there are 31 days in May."
            when 6
                print "#{@spacer}Remember there are 30 days in June."
            when 7
                print "#{@spacer}Remember there are 31 days in July."
            when 8
                print "#{@spacer}Remember there are 31 days in August."
            when 9
                print "#{@spacer}Remember there are 30 days in September."
            when 10
                print "#{@spacer}Remember there are 31 days in October."
            when 11
                print "#{@spacer}Remember there are 30 days in November."
            when 12
                print "#{@spacer}Remember there are 31 days in December."
            end

            #Takes the user's choice and uses a temp variable for event's day.  Event's day.
            print "\n#{@spacer}Please choose a day for the event: "
            day_choice = STDIN.gets.chomp
            while (day_choice.to_i < 1) || (day_choice.to_i > 31)
                day_choice = STDIN.gets.chomp
            end

            @event_day = day_choice.to_i

            #Verifies if the date is a valid date for the event.
            if !(Date.valid_date?(@event_year, @event_month, @event_day))
                invalid_date = true
                puts "#{@spacer}Date is not valid."
            else
                d = Date.new(@event_year, @event_month, @event_day)
                if d < Date.today
                    invalid_date = true
                    puts "#{@spacer}Date is not valid."
                else
                    invalid_date = false
                end
            end
          end
        end

        #Pre: An admin was created and a Date object was created.
        #Post: Gets the times that the event will take place and loads them into timeslots_array.
        #Return: None.
        def create_date_time                                                    #Creation of time.


            start_time_match = true
            print "\n#{@spacer}Please specify a time format: "
            print "\n#{@spacer}'12' for 12 hours or '24' for 24 hour time format?: "
            hour_rep = STDIN.gets.chomp
            while (hour_rep.casecmp("12") != 0) && (hour_rep.casecmp("24") != 0)
                print "#{@spacer}I'm sorry, please enter either 12 or 24: "
                hour_rep = STDIN.gets.chomp
            end

            temp_array = create_time_array(hour_rep)

            if hour_rep == "12"
                #Creates Temporary array for slot validation.
                slot_choices = Array.new
                for i in 0...48
                    num = i + 1
                    slot_choices[i] = num.to_s
                end

                puts "\n#{@spacer}How many time slots would you like to take for this event? \n"
                print "#{@spacer}(Events are scheduled in 30 minute blocks. These blocks can be non-contiguous):"

                #Receive the amount of slots they want to take up then convert.
                slot_choice_s = @drive.validate_input(slot_choices)
                slot_choice_i = slot_choice_s.to_i

                slot_counter = 0
                array_increment = 0
                while slot_counter != slot_choice_i
                    #Retreives the time from the user.
                    print "#{@spacer}Enter a time (i.e., 7:30 P.M.):"
                    time = STDIN.gets.chomp

                    #Checks to see if the time is valid throughout the array.
                    time_match = time_check(time, temp_array)
                    while time_match
                        print "#{@spacer}Must enter a valid time: "
                        time = STDIN.gets.chomp
                        time_match = time_check(time, temp_array)
                    end

                    time = time.split(':')

                    @event_hour = convert_to_military_time(time)

                    minute = time[1].slice(0..1)
                    @event_minute = minute.to_i

                    #Add the time in the temp_array to the temp_timeslot_array.
                    @timeslots_array[array_increment] = DateTime.new(@event_year, @event_month, @event_day, @event_hour, @event_minute)
                    array_increment += 1
                    slot_counter += 1
                end

            elsif hour_rep == "24"
                #Creates Temporary array for slot validation.
                slot_choices = Array.new
                for i in 0...48
                    num = i + 1
                    slot_choices[i] = num.to_s
                end

                puts "\n#{@spacer}How many time slots would you like to take for this event? \n"
                print "#{@spacer}(Events are scheduled in 30 minute blocks. These blocks can be non-contiguous):"

                #Receive the amount of slots they want to take up then convert.
                slot_choice_s = @drive.validate_input(slot_choices)
                slot_choice_i = slot_choice_s.to_i

                slot_counter = 0
                array_increment = 0
                while slot_counter != slot_choice_i
                    print "#{@spacer}Enter a time (i.e., 07:30 or 19:30):"
                    time = STDIN.gets.chomp

                    #Checks to see if the time is valid throughout the array.
                    time_match = time_check(time, temp_array)
                    while time_match
                        print "#{@spacer}Must enter a valid time: "
                        time = STDIN.gets.chomp
                        time_match = time_check(time, temp_array)
                    end

                    time = time.split(':')

                    @event_hour = time[0].to_i

                    minute = time[1].slice(0..1)
                    @event_minute = minute.to_i

                    @timeslot_array[array_increment] = DateTime.new(@event_year, @event_month, @event_day, @event_hour, @event_minute)
                    array_increment += 1
                    slot_counter += 1
                end
            end
        end

        #Pre: A time was given by the user and was then split by a character.
        #Post: Takes the 12 hr time array and converts it to military time.
        #Return: An int representing the hour of the day in military time.s
        def convert_to_military_time(standard_time)
            temp_holder = standard_time[0]
            temp_holder2 = standard_time[1]
            if temp_holder2[4].casecmp('p') == 0
                return (temp_holder.to_i + 12)
            else
                return (temp_holder.to_i)
            end

            raise ArgumentError, '#{@spacer}Could not convert time. Make sure input is formatted as hh:mm a.m. or hh:mm p.m.'
        end

        #Pre: An event was created and persisted to the data base with correct info.
        #Post: If yes, the admin gets to create another event. If no, then the program exits.
        #Return: True if yes, false if no.
        def get_validation
          system 'clear'
          @drive.title_print_ext("Admin Mode")
          @drive.sub_title_print("Event Information")
            print "\n#{@spacer}Event created!"
            print "\n\n#{@spacer}Create another event?(Yes/No): "
            response = STDIN.gets.chomp

            #Check for Alphetical characters
            while !(response =~ /[[:alpha:]]/)
                print "#{@spacer}Not a valid input. Enter Yes/No: "
                response = STDIN.gets.chomp
            end

            #Check for if the answer is yes or no.
            while (response.casecmp("yes") != 0) && (response.casecmp("no") != 0)
                print "#{@spacer}Not a valid input. Enter Yes/No: "
                response = STDIN.gets.chomp
            end

            #Sets a temp variable to return to call.
            if ((response.casecmp("no")) == 0)
                return true
            elsif ((response.casecmp("yes")) == 0)
                return false
            end
        end

        #Pre: The user enters a vaild time representation of time.
        #Post: An array is created with either military time or 12 hr time.
        #Return: If 12, an array with 12 hr representation, if 24, and array with 24 hr representation.
        def create_time_array(hr)
            if hr == "12"                                                   #12Hr time
                hour_counter = 1

                #Creates an array with 12 hour time slots.
                twelve_hr_array = Array.new
                twelve_hr_array[0] = "12:00 A.M."
                twelve_hr_array[1] = "12:30 A.M."

                #Fills the array with the hourly time slots
                for i in 2...48
                    if i % 2 == 0
                        if i < 24
                            if i <= 19
                                twelve_hr_array[i] = (hour_counter.to_s + ":00 A.M.")
                            elsif i > 19
                                twelve_hr_array[i] = (hour_counter.to_s + ":00 A.M.")
                            end
                        elsif i >= 24
                            twelve_hr_array[i] = (hour_counter.to_s + ":00 P.M.")
                        end
                    elsif i % 2 == 1
                        if i < 24
                            if i <= 19
                                twelve_hr_array[i] = (hour_counter.to_s + ":30 A.M.")
                            elsif i > 19
                                twelve_hr_array[i] = (hour_counter.to_s + ":30 A.M.")
                            end
                        elsif i >= 24
                            twelve_hr_array[i] = (hour_counter.to_s + ":30 P.M.")
                        end
                    end

                    if i % 2 == 1
                        hour_counter += 1
                    end

                    #Resets hour_counter to 0 once it reaches 1 o'clock.
                    if hour_counter == 13
                        hour_counter = 1
                    end
                end

                return twelve_hr_array
            elsif hr == "24"                                                #24Hr time
                hour_counter = 0

                #Creates an array with 24 hour time slots.
                twentyfour_hr_array = Array.new

                #Fills the array with the hourly time slots
                for i in 0...48
                    if i % 2 == 0
                        if i < 24
                            if i <= 19
                                twentyfour_hr_array[i] = ("0" + hour_counter.to_s + ":00")
                            elsif i > 19
                                twentyfour_hr_array[i] = (hour_counter.to_s + ":00")
                            end
                        elsif i >= 24
                            twentyfour_hr_array[i] = (hour_counter.to_s + ":00")
                        end
                    elsif i % 2 == 1
                        if i < 24
                            if i <= 19
                                twentyfour_hr_array[i] = ("0" + hour_counter.to_s + ":30")
                            elsif i > 19
                                twentyfour_hr_array[i] = (hour_counter.to_s + ":30")
                            end
                        elsif i >= 24
                            twentyfour_hr_array[i] = (hour_counter.to_s + ":30")
                        end
                    end

                    if i % 2 == 1
                        hour_counter += 1
                    end
                end

                return twentyfour_hr_array
            end
        end

        #Pre: A time was input by the user and an array with a time representation was created.
        #Post: The user's input time was checked to see if it was in the time array.
        #Return: If the time IS in the array, then true. If the time IS NOT in the array, then false.
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


#-------------------------------------------------------------------------------
#                             Abe's Code
#-------------------------------------------------------------------------------
    def run2
        setup()
        get_events
        single_event_printer
    end

    def setup
        @db = DatabaseController.new
        @event_array = @db.get_events
        @number_of_events = @event_array.length
        @events = true
        @browsing = true
    end

    def get_events
            if @events  == true
                system "clear"
                @drive.title_print_ext("Events")
                @drive.sub_title_print("Upcoming Events")
                print "\n"

                # Grab each event
                    for i in 0...@event_array.length
                        @drive.hr
                        single_event_printer(@event_array[i],false)
                    end
            else
                print "There are not currently any events in the database\n"
            end
        end

        # @desc: Template for printing a single event
        # @pre: takes an event and a bool flag to indicate if more than one event will eventually be printed
        # @post: prints events
        # @return: none
        def single_event_printer(event,single)

            if !single
                puts "\n\n#{@spacer}Event ID:\t" + event.get_id.to_s
            end

            puts "\n#{@spacer}Event Name:\t" + event.get_name
            puts "#{@spacer}Date:\t\t" + event.get_date.strftime('%A %B %d, %Y')
            print "#{@spacer}Time(s)"

            if !@military_time
                print " (12hr):"
            else
                print " (24hr): "
            end

            for j in 0...event.get_timeslots.length
                if !@military_time
                    print event.get_timeslots[j].strftime('%l:%M%P')
                else
                    print event.get_timeslots[j].strftime('%H:%M')
                end

                if j != event.get_timeslots.length-1
                    print ", "
                end
            end

            print "\n#{@spacer}Attendees:\t"

            if event.get_attendees.empty?
                print "None yet, be the first to attend!\n"
            else
                for i in 0...event.get_attendees.length
                    if event.get_attendees[i].get_timeslots.length != event.get_timeslots.length
                        print event.get_attendees[i].get_name() + " ("
                        for j in 0...event.get_attendees[i].get_timeslots.length
                            if @military_time
                                print event.get_attendees[i].get_timeslots[j].strftime('%l:%M')
                            else
                                print event.get_attendees[i].get_timeslots[j].strftime('%H:%M%P')
                            end
                            if j != event.get_attendees[i].get_timeslots.length-1
                                print ", "
                            end
                        end
                        print " )"
                    else
                        print event.get_attendees[i].get_name()
                    end

                    if i != event.get_attendees.length-1
                        print ", "
                    end
                end
            end
            print "\n"

            print "\n#{@spacer}Description:\t"
            @drive.desc_printer(event.get_description)
            print "\n"
        end
end
