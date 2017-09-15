=begin
    File: control.rb
    Author:
    Date Created: 9/15/17
    Description:
=end

# Contains support methods for admin and user classes
class Control
    def initialize
        #empty initializer
    end

    # Takes a string (message) and validates user input to only allow
    # responses that only contain upper and lowercase letters
    def get_alpha(message)
        loop do
            print message + " "
            @input = STDIN.gets.chomp

            if @input.match(/^[[:alpha:]]+$/)
                break
            else
                print "\n        Only letters are allowed"
            end
            
        end

        return @input
    end

    # takes an array of acceptable answers and only allows the user to
    # choose from that list
    def validate_input(acceptable_input)
        @user_input = ""

        while !acceptable_input.include? @user_input
            print "\n        Choice: "
            @user_input = STDIN.gets.chomp
        end

        return @user_input
    end

    #converts a single time to military time for use with creating attendee
    def convert_to_military_time(standard_time)
        
        if standard_time[5] == 'p'
            standard_time.chop
            standard_time.chop
            @temp_holder = @standardtime.split(':')
            @temp_holder[0] = @temp_holder[0].to_i + 12
            @temp_holder[0].to_s
            @mt = @temp_holder[0] + ":" + @temp_holder[1]

            return @mt
        else
            standard_time.chop
            standard_time.chop
            return standard_time
        end

        raise ArgumentError, 'Could not convert time. Make sure input is formatted as hh:mmam or hh:mmpm'

    end

end