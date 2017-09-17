=begin
    File: databaseController.rb
    Author: Alex Shadley
    Date Created: 9/8/17
    Description: controller class to encapsulate all database calls
=end

require 'sequel'
require 'sqlite3'

class DatabaseController

    def initialize
		@DB = Sequel.sqlite('db.sqlite')
		@epoch = DateTime.now
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

		if(!@DB.table_exists?(:timeslots))
			@DB.create_table :timeslots do
				String :time
				String :parent_table
				String :parent_id
			end
		end

		if(!@DB.table_exists?(:attendees))
			@DB.create_table :attendees do
				primary_key :id
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
			id = @DB[:events].insert(:name => event.get_name, :description => event.get_description, :date => event.get_date)

			event.get_timeslots.each do |timeslot|
				@DB[:timeslots].insert(:time => timeslot, :parent_table => 'events', :parent_id => id)
			end

			event.get_attendees.each do |attendee|
				persist_attendee(attendee, id)
			end
		end
	end

	# persists a single attendee to the database, for use within the class only
	# Params:
	# +attendee+:: Attendee object to be persisted
	# +parentid+:: id of the database entry the attendee is attached to
	def persist_attendee(attendee, parentid)
		id = @DB[:attendees].insert(:name => attendee.get_name, :parent_id => parentid)

		attendee.get_timeslots.each do |timeslot|
			@DB[:timeslots].insert(:time => timeslot, :parent_table => 'attendees', :parent_id => id)
		end
	end

	def update_event(event)
		eventDataset = @DB[:events].where(id: event.get_id)
		attendeeDataset = @DB[:attendees].where(parent_id: event.get_id)

		#if there are any missing attendees from the attendee table, add them
		event.get_attendees.each do |attendee|
			if attendeeDataset.where(name: attendee.get_name).empty?
				persist_attendee(attendee, event.get_id)
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

		@DB[:events].order(:date).each do |event|
			newTimeslots = []
			@DB[:timeslots].where(parent_table: 'events', parent_id: event[:'id']).each do |timeslot|
				newTimeslots.push(DateTime.parse(timeslot[:'time']))
			end

			newAttendees = []
			@DB[:attendees].where(parent_id: event[:'id']).each do |attendee|
				attendeeTimeslots = []
				@DB[:timeslots].where(parent_table: 'attendees', parent_id: attendee[:'id']).each do |timeslot|
					attendeeTimeslots.push(DateTime.parse(timeslot[:'time']))
				end

				newAttendee = Attendee.new(attendee[:'name'], attendeeTimeslots)
				newAttendees.push(newAttendee)
			end

			newEvent = Event.new(event[:'name'], event[:'description'], newTimeslots, newAttendees, event[:'id'])
			if newEvent.get_date >= @epoch
				events.push(newEvent)
			end
		end

		return events
	end

end
