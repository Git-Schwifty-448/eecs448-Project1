=begin
    File: event.rb
    Author:
    Date Created: 9/10/17
    Description:
=end

class Event
        def initialize(name, description, date, timeslots,attendees)
            @name = name
            @description = description
            @date = date
            @timeslots = timeslots #contains strings with the timeslots to choose from
            @attendees = attendees #contains strings with the names of attendees
        end
    
        def addAttendee(name)
            @attendees.push(name)
        end
    
        def getName
            @name
        end
    
        def getDescription
            @description
        end
    
        def getDate
            @date
        end
    
        def getTimeslots
            @timeslots
        end

        def getTimeslots12hrs
            #create the new array
            @timeslots_12hrs = Array.new


            for i in 0...@timeslots.length

                @temp_holder = @timeslots[i].split(':')
                @temp_holder[0] = @temp_holder[0].to_i

                if @temp_holder[0] > 12  
                    @temp_holder[0] = @temp_holder[0] - 12
                    @timeslots_12hrs.push(@temp_holder[0].to_s + ":" + @temp_holder[1] + "pm")
                else
                    @timeslots_12hrs.push(@timeslots[i] + "am")
                end
            end

            return @timeslots_12hrs

        end
    
        def getAttendees
            @attendees
        end

        def addAttendees(to_add)
            @attendees.push(to_add)
        end
    
    end
