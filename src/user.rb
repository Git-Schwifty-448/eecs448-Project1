=begin

    File: user.rb
    Author:
    Date Created: 9/8/17
    Description: 

=end

require 'date'

require_relative 'event'
require_relative 'databaseController'

class User
    
    def initialize
        @user_name = String.new
        @drive = Driver.new
        @events = false
        @military_time = true
        @number_of_events = 0
        @spacer = "        "
    end

    def run
        @db = DatabaseController.new

        #eventually this will be pulling events from the database based on the time list
        @e1_times = ["15:00","23:30","17:30"]
        @e1 = Event.new("Awesome PArty","This is the desc of the first of the events in a series of 3 events that will be here to demonstrate how this works and how it will continue to work for as long as there are characters in the string that still need printing",Date.new(2018,3,18),@e1_times,["Abe"])            
        @e2 = Event.new("Git wrecked","new e2",Date.parse('01-03-2017'),["12:30","02:00"],["Dick"])
        @e3 = Event.new("heelo","new e3",Date.parse('06-03-2018'),["12:30"],["Alex"]) 
        
        # @db.persist_event(@e1)
        # @db.persist_event(@e2)
        # @db.persist_event(@e3)

        # @event_array = @db.get_events

        @event_array = [@e1,@e2,@e3]
        @number_of_events = @event_array.length
        @events = true

        get_user_name()
        get_events()
        event_controller()
    end

    # updates the member variable @user_name with a name given by the user
    def get_user_name
        system "clear"
        @drive.title_print_ext("User Mode")
        @drive.sub_title_print("Get User Name")

        print "\tPlease enter a username: "
        @user_name = gets.chomp
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
                single_event_printer(@event_array[i],i+1)
            end
        else
            print "There are not currently any events in the database\n"
        end
    end

    # Template for printing a single event
    def single_event_printer(event,id)

        puts "\n\n#{@spacer}Event ID:\t" + id.to_s
        puts "\n#{@spacer}Event Name:\t" + event.getName
        puts "#{@spacer}Date:\t\t" + event.getDate.strftime("%m/%d/%Y")
        print "#{@spacer}Time(s)"

        if !@military_time
            print " (12hr): "
        else
            print " (24hr): "
        end

        # make sure the event was created correctly
        if event.getTimeslots.kind_of?(Array)
            for j in 0...event.getTimeslots.length
                print event.getTimeslots[j]
                if j != event.getTimeslots.length-1
                    print ", "
                end
            end
        else
            print "Should be an array!\n"
        end

        print "\n#{@spacer}Attendees:\t"

        if event.getAttendees.empty?
            print "None yet, be the first to attend!\n"
        end

        if event.getAttendees.kind_of?(Array)

            for i in 0...event.getAttendees.length
                print event.getAttendees[i]
                if i != event.getAttendees.length-1
                    print ", "
                end

            end
            print "\n"
        else
            print "Should be an array!\n"
        end

        print "\n#{@spacer}Description:\t"
        @drive.desc_printer event.getDescription

    end

    # outputs each event and returns if the user wants to attend
    def event_controller()

        @drive.hr

        puts "\n\n#{@spacer}If you wish to attend an event, enter the Event's ID number otherwise enter t to toggle time"
        puts "#{@spacer}format or \"Quit\" to end the application\n"

        # set up the user input and create the array of acceptable responces
        @user_input = ""
        @acceptable_input = Array.new
        @acceptable_input.push(*['t','q',"quit","Quit"])

        for i in 1...@number_of_events+1
            @acceptable_input.push(i.to_s)
        end

        # get user input
        while !@acceptable_input.include? @user_input
            print "\n#{@spacer}Choice: "
            @user_input = gets.chomp
        end

        if @user_input.match(/\d/)
            @user_input = @user_input.to_i
        end

        # handle input
        case @user_input
            when 1...@number_of_events+1
                attend_event(@user_input)
                exit
            when 'n'
                # go grab the next entry
                exit
            when 't'
                #repring the event with military time flipped
                if !@military_time
                    @military_time = true
                else
                    @military_time = false
                end

                get_events()
                event_controller()
                exit
        end
    end
    
    def attend_event(event_id)
        puts "hello from attend event!"
    end
end