=begin

    File: event.rb
    Author:
    Date Created: 9/10/17
    Description:

=end

class Event

    #Contstructor method
    def initialize
      @name, @date, @time, @description
    end

    #Accessor methods
    def getName
      @name
    end

    def getDate
      @date
    end

    def getTime
      @time
    end

    def getDescription
      @description
    end

    #Setter methods
    def setName(theName)
      @name = theName
    end

    def setDate(theDate)
      @date = theDate
    end

    def setTime(theTime)
      @time = theTime
    end

    def setDescription(theDescription)
      @description = theDescription
    end
    



end
