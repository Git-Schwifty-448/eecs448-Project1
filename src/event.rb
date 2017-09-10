=begin

    File: event.rb
    Author: Qualen Pollard
    Date Created: 9/10/17
    Description: Represents an event s

=end

class Event

    #Contstructor method
    def initialize
      @attendee, @month, @weekDay, @day, @time, @description
    end

    #Accessor methods
    def getAttendee
      @attendee
    end

    def getMonth
      @month
    end

    def getWeekDay
      @weekDay
    end

    def getDay
      @day
    end

    def getTime
      @time
    end

    def getDescription
      @description
    end

    #Setter methods
    def setAttendee(theAttendee)
      @attendee = theAttendee
    end

    def setMonth(theMonth)
      @month = theMonth
    end

    def setWeekDay(theWeekDay)
      @weekDay = theWeekDay
    end

    def setDay(theDay)
      @day = theDay
    end

    def setTime(theTime)
      @time = theTime
    end

    def setDescription(theDescription)
      @description = theDescription
    end


end
