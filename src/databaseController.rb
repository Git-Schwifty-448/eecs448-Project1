=begin

    File: databaseController.rb
    Author:
    Date Created: 9/8/17
    Description:

=end

require 'sequel'
require 'sqlite3'

class DatabaseController

    def initialize
		@DB = Sequel.sqlite('db.sqlite')
		init_database
    end

	# checks to see if database tables exist and creates them if not
	def init_database
		if(!@DB.table_exists?(:events))
			@DB.create_table :events do
				primary_key :id
				String :name
				String :description
				String :date
				String :timeslots
			end
		end

		if(!@DB.table_exists?(:attendees))
			@DB.create_table :attendees do
				String :name
				String :parent_id
			end
		end
	end

	# takes an event object as a parameter, then persists the event and its
	# attendees to the database
	#
	# NOTE: since sqlite doesn't support subtables, attendees are put in a
	# separate table, with the parent_id field referencing the event the
	# attendee belongs to
	def persist_event(event)
		@DB.transaction do
			id = @DB[:events].insert(:name => event.getName, :description => event.getDescription, :date => event.getDate, :timeslots => event.getTimeslots)

			event.getAttendees.each do |attendee|
				@DB[:attendees].insert(:name => attendee, :parent_id => id)
			end
		end
	end

	# returns sorted array of events
	#
	# example usage:
	# events = dbController.get_events
	# events[0].getName
	# etc.
	#
	# TODO: sort array
	def get_events()
		events = []

		@DB[:events].each do |event|
			newEvent = Event.new(event[:"name"], event[:"description"], event[:"date"], event[:"timeslots"])

			@DB[:attendees].where(parent_id: event[:"id"]).each do |attendee|
				newEvent.addAttendee(attendee[:"name"])
			end

			events.push(newEvent)
		end

		return events
	end

end
