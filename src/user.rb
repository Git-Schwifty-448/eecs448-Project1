=begin

    File: user.rb
    Author:
    Date Created: 9/8/17
    Description: 

=end

class User
    
        def initialize
            @drive = Driver.new
            @events = false
            @militaryTime = false;
        end

        def run

            @events = true                              # only for testing

            getEvents()
        end

        def getEvents
            if(@events  == true) 
                print "\n\n"
                @drive.title_print("Events")

                # get the first event from the database

                @name = "Event Sample"
                @date = "10/9/17"
                @time = ["3:30pm","4:00pm"]
                @attendees = "Alex, Q, Abe"
                
                send = [@name,@date,@time,@attendees]

                eventTray(send)



            else
                print "There are not currently any events in the database\n"
            end
        end

        # outputs a single event as an array to send to eventTray
        def singleEventPrinter

        end

        # outputs each event and returns if the user wants to attend
        def eventTray(data)

            @title = "Upcoming Events"

            if(@militaryTime == false)
                @title = @title + " (12hr)"
            else 
                @title = @title + " (24hr)"
            end

            @drive.sub_title_print(@title)

            puts "\n Event Name: " + data[0]
            puts "       Date: " + data[1]
            print "    Time(s): "
            
            if data[2].kind_of?(Array)
                for i in 0...data[2].length
                    print data[2][i]
                        if i != data[2].length-1
                            print ", "
                        end
                end
                print "\n"
            else
                print data[2] + "\n"
            end

            puts "  Attendees: " + data[3]

            print "\n    Toggle time format with t"

            @input_char = ''

            while (@input_char != 'y') && (@input_char != 'n') && (@input_char != 't')
                print "\n\n    Do you wish to attend this event?: (y/n) "
                @input_char = gets.chomp
            end

        end
            
    end