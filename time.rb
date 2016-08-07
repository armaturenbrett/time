$widget_scheduler.every '1s' do
  now = Time.zone.now
  time = {
    hour: now.strftime('%H'),
    minute: now.strftime('%M'),
    seconds: now.strftime('%S')
  }
  date = {
    year: now.strftime('%Y'),
    month: now.strftime('%m'),
    day: now.strftime('%d'),
    weekday: now.strftime('%A')
  }
  ActionCable.server.broadcast 'time_widget',
                               { time: time, date: date }
end
