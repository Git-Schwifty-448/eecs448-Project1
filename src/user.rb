=begin

    File: user.rb
    Author: Abraham Dick
    Date Created: 9/8/17
    Description: 

=end

=begin


### TODOS ###

x) When a current user has added themselves to the list of events, they should no longer be able to accept it
3) Fix scoping issues (public v private)

Add features
1) Only show events in which the user is not attending in the viewer list. Make this switchable
    or otherwise disallow the user from going to an event twice

=end

require 'date'

require_relative 'event'
require_relative 'databaseController'
require_relative 'attendee'

class User
    def initialize
        @user_name = String.new
        @drive = Driver.new
        @events = false
        @military_time = true
        @number_of_events = 0
        @spacer = "        "
        @attendee_created = false
        @attending_events = Array.new
        @view_all = false
    end

    def testing
        @at1 = Attendee.new("Abe",["15:00,23:30,17:30"])
        @e1 = Event.new("Awesome PArty","This isrks and how it wilg","03/18/2017",["15:00,23:30,17:30"],[@at1],1) 
        @db = DatabaseController.new
        @db.persist_event(@e1)
        @event_array = @db.get_events
    end

    def run

        @db = DatabaseController.new
        

        ### DEBUG CODE RUN ONCE
        # creates a test database
        
        # @at1 = Attendee.new("Abe Dick",["15:00","23:30","17:30"])
        # @at2 = Attendee.new("Zach Jones",["12:30","02:00"])
        # @at3 = Attendee.new("Ryan Martin",["12:30"])
        # @at4 = Attendee.new("Mike Kitchen",["12:30"])
        # @at5 = Attendee.new("Zyke Joynes",["12:30"])
        # @at6 = Attendee.new("Myke Tyson",["12:30"])

        # @e1 = Event.new("A large gathering","A typical large gathering of friends for an hour and a half in March","18-11-2017",["15:00","23:30","17:30"],[@at1])            
        # @e2 = Event.new("Coffee Break","Let's take coffee sometime?","01-12-2017",["12:30","02:00"],[@at2,@at3])
        # @e3 = Event.new("Lunch Beer","Who doesn't love a lunch beer?","15-12-2017",["12:30"],[@at4,@at5,@at6]) 

        # @db.persist_event(@e1)
        # @db.persist_event(@e2)
        # @db.persist_event(@e3)

        ### END RUN ONCE

        @event_array = @db.get_events
        # @event_array = [@e1,@e2,@e3]
        @number_of_events = @event_array.length

        @events = true
        @browsing = true

        if @number_of_events > 0

            while @browsing
                get_events()
                @browsing = event_controller()
            end

            reminder()
        else
            @drive.title_print("Error")
            print "\n\n#{@spacer}There are not currently any events in the database\n"
            print "#{@spacer}Please use admin mode and add an event first!\n\n"
        end

        if !@attending_events.empty?
            for i in 0...@attending_events.length
                @db.update_event(@attending_events[i])
            end
        end

    end

    # If there are events stored in the database, they are grabbed 
    # and printed to terminal window (via single_event_printer). 
    # If there are no events, a message is printed as such   
    def get_events
        if @events  == true
            system "clear"
            @drive.title_print_ext("Events")
            @drive.sub_title_print("Upcoming Events")
            print "\t(use t to toggle 12 or 24 hour time formats)\n"

            # Grab each event
                for i in 0...@event_array.length
                    @drive.hr
                    single_event_printer(@event_array[i],false)
                end
 
        else
            print "There are not currently any events in the database\n"
        end
    end

    # Template for printing a single event
    # takes an event object and a true/false if this is for printing in a list
    # or printing a single event
    def single_event_printer(event,single)

        if !single
            puts "\n\n#{@spacer}Event ID:\t" + event.get_id.to_s
        end

        puts "\n#{@spacer}Event Name:\t" + event.get_name

        d = Date.parse(event.get_date)

        puts "#{@spacer}Date:\t\t" + d.strftime('%A %B %d, %Y')
        print "#{@spacer}Time(s)"

        if !@military_time
            print " (12hr): "

            # make sure the event was created correctly
            if event.get_timeslots_12hrs.kind_of?(Array)
                for j in 0...event.get_timeslots_12hrs.length
                    print event.get_timeslots_12hrs[j]
                    if j != event.get_timeslots_12hrs.length-1
                        print ", "
                    end
                end
            else
                print "Should be an array!\n"
            end
        else
            print " (24hr): "

            # make sure the event was created correctly
            if event.get_timeslots.kind_of?(Array)
                for j in 0...event.get_timeslots.length
                    print event.get_timeslots[j]
                    if j != event.get_timeslots.length-1
                        print ", "
                    end
                end
            else
                print "Should be an array!\n"
            end
        end

        print "\n#{@spacer}Attendees:\t"

        if event.get_attendees.empty?
            print "None yet, be the first to attend!\n"
        end

        if event.get_attendees.kind_of?(Array)
            for i in 0...event.get_attendees.length

                if event.get_attendees[i].get_timeslots.length != event.get_timeslots.length
                    print event.get_attendees[i].get_name() + " ("

                    for j in 0...event.get_attendees[i].get_timeslots.length

                        if @military_time
                            print event.get_attendees[i].get_timeslots[j]
                        else
                            print event.get_attendees[i].get_timeslots_12hrs[j]
                        end

                        if j != event.get_attendees[i].get_timeslots.length-1
                            print ", "
                        end
                    end

                    print ")"


                else
                    print event.get_attendees[i].get_name()
                end


                if i != event.get_attendees.length-1
                    print ", "
                end

            end
            print "\n"
        else
            print "Should be an array!\n"
        end

        print "\n#{@spacer}Description:\t"
        @drive.desc_printer event.get_description
        print "\n"

    end

    # outputs each event and returns if the user wants to attend
    def event_controller()

        @drive.hr

        puts "\n\n#{@spacer}If you wish to attend an event, enter the Event's ID number otherwise enter t to toggle time"
        puts "#{@spacer}format or \"Quit\" to end the application\n"

        # set up the user input and create the array of acceptable responces
        @user_input = ""
        @acceptable_input = Array.new
        @acceptable_input.push(*['t',
                                 'q',
                                 "quit",
                                 "Quit"])
        @list_ids = Array.new
        for i in 0...@number_of_events
            @list_ids.push(@event_array[i].get_id.to_s)
        end

        @acceptable_input += @list_ids

        # get user input
        while !@acceptable_input.include? @user_input
            print "\n#{@spacer}Choice: "
            @user_input = STDIN.gets.chomp
        end

        # handle input
        case @user_input
            when *@list_ids
                # @username = get_user_name()
                @browsing = attend_event(get_event_by_id(@user_input))
                return @browsing
            when 'q',"quit","Quit"
                @browsing = false
                return @browsing
            when 't'
                #repring the event with military time flipped
                if !@military_time
                    @military_time = true
                else
                    @military_time = false
                end

                get_events()
                event_controller()
        end
    end
    
    # takes an event given by the event_controller method, the id of that event
    def attend_event(event)

        # If the user has already created an attendee object
        if !@attendee_created
            @new_user = create_user([])
            @attendee_created = true

        # If they selected an event, their timeslots for that event need to be cleared out
        else 
            @new_user = clean_attendee(@new_user)
        end

        # Print the terminal graphics
        system "clear"
        @drive.title_print_ext("Events")
        @drive.sub_title_print("Attend an Event")

        # reprint the details of only the specific event the user is interested in
        single_event_printer(event,true)

        # check to see how many timeslots are availiable and proceed 
        if event.get_timeslots.length > 1

            @drive.hr
            print "\n#{@spacer}For each time slot of an event, indicate with 'y' or 'n' if you wish to attend\n\n"

            # get user responce and if the user wants to attend a specific time, add it to the array of attending events
            for i in 0...event.get_timeslots.length
                @acceptable_input = Array.new
                @acceptable_input.push(*["y",
                                        "Y",
                                        "yes",
                                        "Yes",
                                        "n",
                                        "N",
                                        "No",
                                        "no",
                                        "a",
                                        "A",
                                        "all",
                                        "All"])


                @user_input = ""

                while (!@acceptable_input.include? @user_input)
                    if @military_time
                        print "#{@spacer}#{event.get_timeslots[i]}, attend?: "
                    else
                        print "#{@spacer}#{event.get_timeslots_12hrs[i]}, attend?: "
                    end
                    @user_input = STDIN.gets.chomp
                end

                case @user_input
                    # Add the user
                    when @user_input = "y","Y","yes","Yes"
                        @new_user.add_timeslot(event.get_timeslots[i])
                    # Do nothing
                    when @user_input = "n","N","no","No"
                        # unused
                    # Add all of the timeslots to the user
                    when @user_input = "a","A","all","All"
                        @new_user.clear_timeslot
                        for j in 0...event.get_timeslots.length
                            @new_user.add_timeslot(event.get_timeslots[j])
                        end
                        break
                end
            end

            # if no events were chosen
            if @new_user.get_timeslots.empty?
                print "\n\n#{@spacer}No times selected, returning to event list."
                sleep 2
            else # Add the user to the event and then add the event to the update table
                event.add_attendee(@new_user)
                @attending_events.push(event)
                print "\n\n#{@spacer}Your selections have beens saved!"
                sleep 2
            end


        # Otherwise, assume that the event has only one timeslot
        else
            @new_user.add_timeslot(event.get_timeslots)
            event.add_attendee(@new_user)
            @attending_events.push(event)
            print "\n\n#{@spacer}Your were added to the list!"
            sleep 2
        end

        # return true, that program should continue to loop
        return true

    end

    def reminder
        system "clear"

        if @attending_events.any?
            @drive.title_print_ext("Reminders")
            @drive.sub_title_print("List of Events for #{@user_name}")

            # Grab each event that the user is going to and print it
            for i in 0...@attending_events.length
                @drive.hr
                single_event_printer(@attending_events[i],false)
            end
        else
            @drive.title_print("Thanks for using, goodbye!")
        end

        print "\n\n"
    end


    # Creates an attendee object to be added to the event
    def create_user(origin_time_slot)
        system "clear"
        @drive.title_print_ext("User Mode")
        @drive.sub_title_print("Get User Name")

        @temp_name = String.new

        loop do
            print "\n\n#{@spacer}Please enter your first name: "
            @temp_name = STDIN.gets.chomp

            if @temp_name.match(/^[[:alpha:]]+$/)
                break
            else
                print "\n#{@spacer}Only letters are allowed"
            end
            
        end

        loop do
            print "\n\n#{@spacer}Please enter your last name: "
            @temp_l_name = STDIN.gets.chomp

            if @temp_l_name.match(/^[[:alpha:]]+$/)
                @temp_name = @temp_name + " " + @temp_l_name
                break
            else
                print "\n#{@spacer}Only letters are allowed"
            end
            
        end


        @new_attendee = Attendee.new(@temp_name,origin_time_slot)

        return @new_attendee
    end

    # returns an event object that matches the id passed in, if none found, throws an error
    def get_event_by_id(id_number)
        for i in 0...@event_array.length
            if(@event_array[i].get_id == id_number.to_i)
                return @event_array[i]
            end
        end

        raise ArgumentError, 'The ID does not match an in the database'

    end

    #converts a single time to military time for use with creating attendee
    def convert_to_military_time(standard_time)

        if standard_time[5] == 'p'
            standard_time.chop
            standard_time.chop
            @temp_holder = @standardtime.split(':')
            @temp_holder[0] = @temp_holder[0].to_i + 12
            @temp_holder[0].to_s
            @mt = @temp_holder[0] + ":" + @temp_holder[1]

            return @mt
        else
            standard_time.chop
            standard_time.chop
            return standard_time
        end

        raise ArgumentError, 'Could not convert time. Make sure input is formatted as hh:mmam or hh:mmpm'

    end

    # Resets with the same username to go to multiple events
    def clean_attendee(attendee)
        @name = attendee.get_name
        clean_attendee = Attendee.new(@name,[])
        return clean_attendee
    end


end

=begin GARBAGE                        
                        # DEBUG USE ONLY
                        for i in 0...@sub_acceptable_input.length
                            puts @sub_acceptable_input[i]
                        end

                        # Converts input to an integer
                         if user wants to attend an event, convert it to an integer for easier handling
                         if @user_input.match(/\d/)
                             @user_input = @user_input.to_i
                         end
=end

# username checking from https://stackoverflow.com/questions/6407834/how-can-i-check-my-input-string