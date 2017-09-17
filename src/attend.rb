=begin

    File: attend.rb
    Author: Abraham Dick
    Date Created: 9/8/17
    Description: Attend class controls the the interation involved in adding attendees to existing events

=end

require 'date'

require_relative 'event'
require_relative 'databaseController'
require_relative 'attendee'

class Attend

    # sets up the member variables for Attend class
    def initialize
        @user_name = String.new
        @drive = Driver.new
        @events = false
        @military_time = true
        @number_of_events = 0
        @spacer = "        "
        @attendee_created = false
        @attending_events = Array.new
    end

    # @desc: In charge of control of the attend class. Runs the setup to get database data,
    # runs the program, and then posts the events back to the database
    # @pre: none
    # @post: main controller for the program
    # @return: none
    def run
        setup()

        # if there are events to be retrieved, print the list of them and then begin the controller method
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

        # @pre: none
        # @post: posts updated events to the database with new attendee information
        # @return: none
        if !@attending_events.empty?
            for i in 0...@attending_events.length
                @db.update_event(@attending_events[i])
            end
        end
    end

    private

        # @pre: none
        # @post: creates a database controller object retrieves the events, also sets some bool flags depending on what the database returns
        # @return: none
        def setup
            @db = DatabaseController.new
            @event_array = @db.get_events
            @number_of_events = @event_array.length
            @events = true
            @browsing = true
        end

        # @pre: none
        # @post:If there are events stored in the database, they are retrieved 
        #       and printed to terminal window (via single_event_printer). 
        #       If there are no events, a message is printed as such  
        # @return: none 
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
            @drive.desc_printer event.get_description
            print "\n"
        end

        # @pre: None 
        # @post: outputs each event and returns if the user wants to attend
        # @return: None
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
            # get all of the ID's in the database array
            @list_ids = Array.new
            for i in 0...@number_of_events
                @list_ids.push(@event_array[i].get_id.to_s)
            end

            # get id's of events that the user is attending already
            @already_attending = Array.new
            for i in 0...@attending_events.length
                @already_attending.push(@attending_events[i].get_id.to_s)
            end

            @acceptable_input += @list_ids
            
            # get user input
            while !@acceptable_input.include? @user_input
                print "\n#{@spacer}Choice: "
                @user_input = STDIN.gets.chomp
            end

            @list_ids -= @already_attending
            
            # handle input
            case @user_input
                when *@list_ids
                    # @username = get_user_name()
                    @browsing = attend_event(get_event_by_id(@user_input))
                    return @browsing
                when *@already_attending
                    print "#{@spacer}You are already attending this event!"
                    sleep 2
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
        
        # @pre: an event must be passed
        # @post: the user is guided through adding themselves to an event
        # @return: true to continue looping
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
                            print "#{@spacer}#{event.get_timeslots[i].strftime('%l:%M%P')}, attend?: "
                        else
                            print "#{@spacer}#{event.get_timeslots[i].strftime('%k:%M')}, attend?: "
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

            # Keep the program looping
            return true
        end

        # @pre: none
        # @post: Prints a reminder of the events that the attendee object is attending
        # @return: none
        def reminder
            system "clear"

            if @attending_events.any?
                @drive.title_print_ext("Reminders")
                @drive.sub_title_print("List of Selected Events")

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

        # @pre: takes the time slot of the event the user wishes to attend
        # @post: gets a first and last name and creates the attendee object
        # @return: the new attendee for the event
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
                    print "\n#{@spacer}Only letters are allowed in your first name."
                end
                
            end

            loop do
                print "\n\n#{@spacer}Please enter your last name: "
                @temp_l_name = STDIN.gets.chomp

                if @temp_l_name.match(/^[[:alpha:]]+$/)
                    @temp_name = @temp_name + " " + @temp_l_name
                    break
                else
                    print "\n#{@spacer}Only letters are allowed in your last name."
                end
                
            end

            @new_attendee = Attendee.new(@temp_name,origin_time_slot)
            return @new_attendee
        end

        # pre: takes an int ID number
        # return: finds and returns the event in the event array in which the passed in id number matches
        def get_event_by_id(id_number)
            for i in 0...@event_array.length
                if(@event_array[i].get_id == id_number.to_i)
                    return @event_array[i]
                end
            end

            raise ArgumentError, 'The ID does not match an in the database'
        end

        # @desc: Resets with the same username to go to multiple events
        # @pre: takes an attendee object
        # @post: removes the timeslots but keeps the username of the attendee passed in
        # @return: a 'new' attendee with the same name but no timeslots
        def clean_attendee(attendee)
            @name = attendee.get_name
            clean_attendee = Attendee.new(@name,[])
            return clean_attendee
        end
end