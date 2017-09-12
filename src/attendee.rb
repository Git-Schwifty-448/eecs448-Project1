=begin

    File: attendee.rb
    Author: Alex Shadley
    Date Created: 9/10/17
    Description: stores information about an attendee for a specific event

=end

class Attendee

    def initialize(name, timeslots)
		raise ArgumentError.new("'name' must be a string") if !name.is_a? String
		raise ArgumentError.new("'timeslots' must not be empty") if timeslots.length == 0

		@name = name
		@timeslots = timeslots
    end

	def get_name
		@name
	end

	def get_timeslots
		@timeslots
	end

end
