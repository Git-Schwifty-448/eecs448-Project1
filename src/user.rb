=begin

    File: user.rb
    Author:
    Date Created: 9/8/17
    Description: 

=end

require_relative 'event'
require_relative 'databaseController'

class User
    
    def initialize
        @user_name = String.new
        @drive = Driver.new
        @events = false
        @military_time = true;
    end

    def run

        @db = DatabaseController.new

        #eventually this will be pulling events from the database based on the time list
        # @e1 = Event.new("e1","This is the desc of the first of the events in a series of 3 events that will be here to demonstrate how this works and how it will continue to work for as long as there are characters in the string that still need printing","01/02/17",["15:00","23:30"])            
        # @e2 = Event.new("e2","new e2","01/03/17",["12:30","02:00"])
        # @e3 = Event.new("e3","new e3","06/06/17",["12:30"]) 
        
        # @db.persist_event(@e1)
        # @db.persist_event(@e2)
        # @db.persist_event(@e3)


        @event_array = @db.get_events


        @events = true



        @events = true                              # only for testing

        get_user_name()
        get_events()
        #event_controller()


    end

    # updates the member variable @user_name with a name given by the user
    def get_user_name
        system "clear"
        @drive.title_print_ext("User Mode")
        @drive.sub_title_print("Get User Name")

        print "\tPlease enter a username: "
        @user_name = gets.chomp
    end

    def get_list_events
    
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
                single_event_printer(@event_array[i])
            end
        else
            print "There are not currently any events in the database\n"
        end
    end

    # Template for printing events
    def single_event_printer(event)
        puts "\n       Event Name: " + event.getName
        print "      Description: "
        @drive.desc_printer event.getDescription
        puts "             Date: " + event.getDate
        print "   Time(s)"

        if !@military_time
            print " (12hr): "
        else
            print " (24hr): "
        end

        # make sure the event was created correctly
        if event.getTimeslots.kind_of?(Array)
            for i in 0...event.getTimeslots.length
                print event.getTimeslots[i]
                if i != event.getTimeslots.length-1
                    print ", "
                end
            end
        else
            print "Should be an array!\n"
        end

        print "\n        Attendees: "

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
        else
            print "Should be an array!\n"
        end


    end

    # outputs each event and returns if the user wants to attend
    def event_controller()

        menu = Array.new
        


        case @input_char
            when 'y'
            when 'n'
                # go grab the next entry
            when 't'
                #repring the event with military time flipped
                if !@military_time
                    @military_time = true
                else
                    @military_time = false
                end
        end

    end
            
    end

=begin GARBAGE


            puts "\n    Event Name: " + data[0]
            puts "          Date: " + data[1]
            print "       Time(s)\n"
            if !@military_time
                print "        (12hr): "
            else
                print "        (24hr): "
            end
            
            
            if data[2].kind_of?(Array)
                for i in 0...data[2].length

                    # converter for standard time
                    if !@military_time 
                        
                        @standard_time = String.new

                        @temp_time = data[2][i].split(":")
                        @temp_time[0] = @temp_time[0].to_i

                        if @temp_time[0] > 12
                            @temp_time[0] = @temp_time[0] - 12
                            @temp_time[0] = @temp_time[0].to_s

                            @standard_time = @temp_time[0] + ':' + @temp_time[1] + "pm"
                        else
                            @standard_time = @temp_time[0] + ':' + @temp_time[1] + "am"
                        end

                        print @standard_time
                    else
                        print data[2][i]
                    end

                        if i != data[2].length-1
                            print ", "
                        end
                end
                print "\n"
            else
                print data[2] + "\n"
            end

            puts "     Attendees: " + data[3]

=end