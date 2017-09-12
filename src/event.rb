=begin

    File: event.rb
    Author:
    Date Created: 9/10/17
    Description:

=end

class Event

	# timeslots and attendees must be passed in as arrays, but empty arrays are
	# are acceptable
    def initialize(name, description, date, timeslots, attendees)
		raise ArgumentError.new("'name' must be a string") if !name.is_a? String
		raise ArgumentError.new("'description' must be a string") if !description.is_a? String
		raise ArgumentError.new("'timeslots' must not be empty") if timeslots.length == 0

		@name = name
		@description = description
		@date = date
		@timeslots = timeslots
		@attendees = attendees # contains attendee objects
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

	def get_attendees
		@attendees
	end

end
