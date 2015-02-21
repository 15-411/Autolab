class RealtimeController < WebsocketRails::BaseController

	def updated_submission
	  	print  "\n\n\n\n\n\n\n\n\n\n\n---------->RECEIVED SUBB"
	  	puts "---------->RECEIVED SUBB"
	end

	# WebsocketRails[:].trigger 'new', latest_post
end