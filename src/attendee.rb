=begin
    File: attendee.rb
    Author: Alex Shadley
    Date Created: 9/11/17
    Description: stores information about an attendee for a specific event
=end

class Attendee

        # timeslots and attendees must be passed in as arrays, but empty arrays are
        # are acceptable
        def initialize(name, timeslots)
            raise ArgumentError.new("'name' must be a string") if !name.is_a? String
            # raise ArgumentError.new("'timeslots' must not be empty") if timeslots.length == 0

            @name = name
            @timeslots = timeslots
        end

        def get_name
            @name
        end

        def get_timeslots
            @timeslots
        end

        def add_timeslot(new_slot)
            @timeslots.push(new_slot)
        end

        def clear_timeslot
            @timeslots = []
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
end
