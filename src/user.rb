=begin

    File: user.rb
    Author: Abraham Dick
    Date Created: 9/8/17
    Description: 

=end

=begin


### TODOS ###

1) Username needs to be global for each session (must include first name and last name plus validation)
x) When a current user has added themselves to the list of events, they should no longer be able to accept it
2) Clean up attend_event ... :/
3) Fix scoping issues (public v private)
4) Connect database model
5) Fix time model - 12:30 is 12:30 pm not AM; 00:30 is 12:30am

***Attending events array is an array of the events that will be pushed back to the database to be updated,
    assuming all others will be unchanged

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
        @attending_events = Array.new
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
        #
        # @at1 = Attendee.new("Abe",["15:00,23:30,17:30"])
        # @at2 = Attendee.new("Zach",["12:30","02:00"])
        # @at3 = Attendee.new("Ryan",["12:30","02:00"])
        # @at4 = Attendee.new("Mike",["12:30"])
        # @at5 = Attendee.new("Zyke",["12:30"])
        # @at6 = Attendee.new("Myke",["12:30"])

        # @e1 = Event.new("Awesome PArty","This isrks and how it wilg","03-18-2017",["15:00","23:30","17:30"],[@at1])            
        # @e2 = Event.new("Git wrecked","new e2","01-03-2017",["12:30","02:00"],[@at2,@at3])
        # @e3 = Event.new("heelo","new e3","06-03-2018",["12:30"],[@at4,@at5,@at6]) 

        # @db.persist_event(@e1)
        # @db.persist_event(@e2)
        # @db.persist_event(@e3)

        ### END RUN ONCE

        @event_array = @db.get_events
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
        puts "#{@spacer}Date:\t\t" + event.get_date                 #.strftime("%m/%d/%Y")
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
                print event.get_attendees[i].get_name()
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

            # DEBUG USE ONLY
            for i in 0...@acceptable_input.length
                puts @acceptable_input[i]
            end

        # get user input
        while !@acceptable_input.include? @user_input
            print "\n#{@spacer}Choice: "
            @user_input = STDIN.gets.chomp
        end

        # handle input
        case @user_input
            when *@list_ids
                @username = get_user_name()
                @browsing = attend_event(get_event_by_id(@user_input),@username)
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
    def attend_event(event,username)
        system "clear"
        @drive.title_print_ext("Events")
        @drive.sub_title_print("Attend an Event")

        # reprint the details of only the specific event the user is interested in
        single_event_printer(event,true)

        # check to see how many timeslots are availiable and proceed 
        if event.getTimeslots.length > 1

            print "\n\n#{@spacer}To cancel enter \"Cancel\"\n"
            print "#{@spacer}To toggle time enter 't'\n"
            print "\n#{@spacer}To attend the entire event enter \"All\"\n"
            print "\n#{@spacer}Otherwise select times, one at a time, that you would like to attend\n"
            print "#{@spacer}by entering the time exactly as show above\n"

            # Create the list of acceptable input
            @acceptable_input = Array.new

            if @military_time
                for i in 0...event.getTimeslots.length
                    @acceptable_input.push(event.getTimeslots[i])
                end
            else
                for i in 0...event.getTimeslots12hrs.length
                    @acceptable_input.push(event.getTimeslots12hrs[i])
                end
            end

            @available_time_slots = @acceptable_input.clone

            @acceptable_input.push(*["all",
                                    "All", 
                                    'a',
                                    't',
                                    "return",
                                    "nevermind",
                                    'c',
                                    "cancel",
                                    "Cancel"])

            # get user input
            @user_input = ""

            while !@acceptable_input.include? @user_input
                print "\n#{@spacer}Choice: "
                @user_input = STDIN.gets.chomp
            end

            # process user input
            case @user_input

                # when a time slot is chosen
                when *@available_time_slots

                    @continue_picking = true
                    @slots_chosen = Array.new
                    @slots_chosen.push(@user_input)

                    while @continue_picking
                        
                        # Loop to get more input

                        @sub_input = ""

                        @sub_default_input = ["end",
                                                "End"]
                        @remaining_slots = @available_time_slots - @slots_chosen
                        @sub_acceptable_input = @sub_default_input + @remaining_slots

                        # If the user chooses all availaible time slots
                        if @remaining_slots.length == 0
                            print "\n\n#{@spacer}All slots chosen, added to the list!"
                            event.addAttendees(username)
                            @attending_events.push(event)
                            @continue_picking = false
                            sleep 2
                            break
                        end

                        while !@sub_acceptable_input.include? @sub_input 
                            print "\n#{@spacer}Choose another timeslot or enter \"end\": "
                            @sub_input = STDIN.gets.chomp
                        end

                        case @sub_input
                            # When a time slot is chosen
                            when *@remaining_slots
                                @slots_chosen.push(@sub_input)
                            # When the user choses end
                            when *@sub_default_input
                                #post to event the times that were added

                                @username_time_string = username + "("
                                for i in 0...@slots_chosen.length
                                    @username_time_string = @username_time_string + @slots_chosen[i]
                                    if i != @slots_chosen.length-1
                                        @username_time_string = @username_time_string + ", "
                                    end
                                end
                                @username_time_string = @username_time_string + ")"

                                event.addAttendees(@username_time_string)
                                @attending_events.push(event)

                                print "\n\n#{@spacer}Your were added to the list!"
                                sleep 2
                                @continue_picking = false

                        end

                    end

                # when all time slots are chosen
                when "all","All",'a'
                    @picking_out_times = false
                    event.addAttendees(username)
                    @attending_events.push(event)
                    print "\n\n#{@spacer}Your were added to the list!"
                    sleep 2
                
                # toggle the time format
                when 't'
                    #repring the event with military time flipped
                    if !@military_time
                        @military_time = true
                    else
                        @military_time = false
                    end
                        attend_event(event,id,username)
            end


        else
            event.addAttendees(username)
            @attending_events.push(event)
            print "\n\n#{@spacer}Your were added to the list!"
            sleep 2
        end

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
                single_event_printer(@attending_events[i],i+1,false)
            end
        else
            @drive.title_print("Thanks for using, goodbye!")
        end

        print "\n\n"
    end


    # updates the member variable @user_name with a name given by the user
    def get_user_name
        system "clear"
        @drive.title_print_ext("User Mode")
        @drive.sub_title_print("Get User Name")

        print "\tPlease enter a username: "
        @user_name = STDIN.gets.chomp

        return @user_name
    end

    def get_event_by_id(id_number)
        for i in 0...@event_array.length
            if(@event_array[i].get_id == id_number.to_i)
                return @event_array[i]
            end
        end
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