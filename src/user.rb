=begin

    File: user.rb
    Author:
    Date Created: 9/8/17
    Description: 

=end

require_relative 'event'

class User
    
        def initialize
            @user_name = String.new
            @drive = Driver.new
            @events = false
            @military_time = true;
        end

        def run

            @events = true                              # only for testing

            get_user_name()
            get_events()

        end

        # updates the member variable @user_name with a name given by the user
        def get_user_name
            system "clear"
            @drive.title_print("User Mode")
            @drive.sub_title_print("Get User Name")

            print "Please enter a username: "
            @user_name = gets.chomp
        end

        def get_list_events
        
        end


        def get_events

            #eventually this will be pulling events from the database based on the time list
                @e1 = Event.new("e1","new e1","01/02/17",["15:00","23:30"])            
                @e2 = Event.new("e2","new e2","01/03/17",["12:30","02:00"]) 
                
                @event_array = [@e1,@e2]
                @events = true


            # if there are events to grab
            if @events  == true

                system "clear"
                @drive.title_print("Events")
                @drive.sub_title_print("Upcoming Events")
                print "    (use t to toggle 12 or 24 hour time formats)\n"

                # Grab each event
                for i in 0...@event_array.length
                    # Print each event
                    single_event_printer(@event_array[i])
                end

                # event_controller()


            else
                print "There are not currently any events in the database\n"
            end
        end

        # Template for printing events
        def single_event_printer(event)
            puts "\n       Event Name: " + event.getName
            puts "      Description: " + event.getDescription
            puts "             Date: " + event.getDate
            print "          Time(s)\n"

            if !@military_time
                print "           (12hr): "
            else
                print "           (24hr): "
            end

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

            puts "\n        Attendees: "

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
        def event_controller(event)


            system "clear"
            @drive.title_print("Events")
            @drive.sub_title_print("Upcoming Events")

            single_event_printer(data)

            print "\n    Toggle time format with t"

            @input_char = ''

            while (@input_char != 'y') && (@input_char != 'n') && (@input_char != 't')
                print "\n\n    Do you wish to attend this event?: (y/n) "
                @input_char = gets.chomp
            end


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
                    system "clear"
                    event_tray(data)
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