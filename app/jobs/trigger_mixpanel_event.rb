class TriggerMixpanelEvent < ApplicationJob
  queue_as :default

  def perform(unique_id, event_name, data)
   AddEventMixpanel.new(unique_id, event_name, data).call
  end
end