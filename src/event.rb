=begin
    File: event.rb
    Author:
    Date Created: 9/10/17
    Description:
=end

class Event
        def initialize(name, description, date, timeslots)
            @name = name
            @description = description
            @date = date
            @timeslots = timeslots
            @attendees = Array.new #contains strings with the names of attendees
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
    
        def getAttendees
            @attendees
        end
    
    end