=begin
    File: event.rb
    Author:
    Date Created: 9/10/17
    Description:
=end

class Event

    # timeslots and attendees must be passed in as arrays, but empty arrays are
    # are acceptable
    def initialize(name, description, date, timeslots, attendees, id = nil)
        raise ArgumentError.new("'name' must be a string") if !name.is_a? String
        raise ArgumentError.new("'description' must be a string") if !description.is_a? String
        raise ArgumentError.new("'timeslots' must not be empty") if timeslots.length == 0

        @name = name
        @description = description
        @date = date
        @timeslots = timeslots
        @attendees = attendees # contains attendee objects

        if id
            @id = id
        end
    end

    def add_attendee(attendee)
        raise ArgumentError.new("must be passed an attendee object") if !attendee.is_a? Attendee
        @attendees.push(attendee)
    end

    def get_name
        @name
    end

    def get_description
        @description
    end

    def get_date
        @date
    end

    def get_timeslots
        @timeslots
    end

    def get_timeslots_12hrs
        #create the new array
        @timeslots_12hrs = Array.new

        for i in 0...@timeslots.length
            @temp_holder = @timeslots[i].split(':')
            @temp_holder[0] = @temp_holder[0].to_i

            if @temp_holder[0] > 12  
                @temp_holder[0] = @temp_holder[0] - 12
                @timeslots_12hrs.push(@temp_holder[0].to_s + ":" + @temp_holder[1] + "pm")
            elsif @temp_holder[0] == 12
                @timeslots_12hrs.push(@temp_holder[0].to_s + ":" + @temp_holder[1] + "pm")
            else
                @timeslots_12hrs.push(@timeslots[i] + "am")
            end
        end

        return @timeslots_12hrs
    end

    def get_attendees
        @attendees
    end

    def get_id
        @id
    end
end