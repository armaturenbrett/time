$widget_scheduler.every '10s' do
  ActionCable.server.broadcast 'time_widget',
                               Time.zone.now
end
