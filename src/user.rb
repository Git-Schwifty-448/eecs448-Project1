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

                name = "Event Sample"
                date = "10/9/17"
                time = ["3:30pm","4:00pm"]
                attendees = "Alex, Q, Abe"
                
                eventTray(name,date,time,attendees)



            else
                print "There are not currently any events in the database\n"
            end
        end

        # outputs a single event as an array to send to eventTray
        def singleEvent

        end

        # outputs each event and returns if the user wants to attend
        def eventTray(name,date,time,attendees)

            @title = "Upcoming Events"

            if(@militaryTime == false)
                @title = @title + " (12hr)"
            else 
                @title = @title + " (24hr)"
            end
            
            @title = @title + " (Toggle with t)"

            @drive.sub_title_print(@title)


        end
            
    end