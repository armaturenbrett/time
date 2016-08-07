App.widget_data = App.cable.subscriptions.create channel: 'WidgetDataChannel', widget: 'time',
  connected: ->
    console.log('connected')

  disconnected: ->
    console.log('disconnected')

  received: (data) ->
    console.log('received data:', data)
