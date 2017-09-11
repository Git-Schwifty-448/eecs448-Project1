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
    
        def getAttendees
            @attendees
        end
    
    end
