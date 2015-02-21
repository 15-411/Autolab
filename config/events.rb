WebsocketRails::EventMap.describe do
  subscribe :updated_submission, :to => RealtimeController, :with_method => :updated_submission
end
