class RealtimeController < WebsocketRails::BaseController


	def incoming_message
	  	print  "\n\n\n\n\n\n\n\n\n\n\n---------->RECEIVED MSG"
	  	puts "---------->RECEIVED MSG"

		broadcast_message :new_message, { :text => message[:text]}
	end

	def updated_submission
	  	print  "\n\n\n\n\n\n\n\n\n\n\n---------->RECEIVED SUBB"
	  	puts "---------->RECEIVED SUBB"
	end

	# WebsocketRails[:].trigger 'new', latest_post

end