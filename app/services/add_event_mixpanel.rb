class AddEventMixpanel
	attr_reader :unique_id, :event_name, :data

	def initialize(unique_id, event_name, data)

		puts "in initializer"
		@unique_id		= unique_id
		@event_name		= event_name
		@data			= data
	end

	def call
		begin
			$tracker.track(@unique_id, @event_name, @data)
		rescue Exception
		# ignored
			puts "Mixpanel sync failed for #{@event_name}"
		end
	end
end