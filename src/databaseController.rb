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

	def init_database
		if(!@DB.table_exists?(:events))
			@DB.create_table :events do
				String :name
				String :description
				String :date
				String :timeslots
			end
		end
	end

	def persist_event(event)
		@DB.transaction do
			@DB[:events].insert(:name => event.getName, :description => event.getDescription, :date => event.getDate, :timeslots => event.getTimeslots)
		end
	end
end
