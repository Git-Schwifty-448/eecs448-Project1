=begin

    File: event.rb
    Author:
    Date Created: 9/10/17
    Description:

=end

class Event

	# timeslots and attendees must be passed in as arrays, but empty arryas are
	# are acceptable
    def initialize(name, description, date, timeslots, attendees)
		@name = name
		@description = description
		@date = date
		@timeslots = timeslots
		@attendees = attendees #contains strings with the names of attendees
    end

	def add_attendee(name)
		@attendees.push(name)
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
