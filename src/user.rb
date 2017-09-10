=begin

    File: user.rb
    Author:
    Date Created: 9/8/17
    Description: 

=end

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
            @drive.title_print("User Mode")
            @drive.sub_title_print("Get User Name")

            print "Please enter a username: "
            @user_name = gets.chomp
        end


        def get_events
            if(@events  == true) 
                print "\n\n"
                

                # get the first event from the database

                @name = "Event Sample"
                @date = "10/9/17"
                @time = ["15:30","16:00"]
                @attendees = "Alex, Q, Abe"
                
                send = [@name,@date,@time,@attendees]

                event_tray(send)



            else
                print "There are not currently any events in the database\n"
            end
        end

        # outputs a single event as an array to send to eventTray
        def single_event_printer(data)

            puts "\n Event Name: " + data[0]
            puts "       Date: " + data[1]
            print "    Time(s): "
            
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

            puts "  Attendees: " + data[3]
        end

        # outputs each event and returns if the user wants to attend
        def event_tray(data)
            @drive.title_print("Events")
            @title = "Upcoming Events"

            if(@militaryTime == false)
                @title = @title + " (12hr)"
            else 
                @title = @title + " (24hr)"
            end

            @drive.sub_title_print(@title)

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
                when 't'
                    #repring the event with military time flipped
                    if !@military_time
                        @military_time = true
                    else
                        @military_time = false
                    end

                    event_tray(data)
            end

        end
            
    end