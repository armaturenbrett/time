App.widget_data = App.cable.subscriptions.create channel: 'WidgetDataChannel', widget: 'time',
  connected: ->
    console.log('connected')

  disconnected: ->
    console.log('disconnected')

  received: (data) ->
    console.log('received data:', data)
    window.timeWidget.referenceDate = new Date(data)

class TimeWidget

  _this = undefined

  constructor: ->
    _this = this

    this.$widget = $('.widget > .time')
    this.template = this.$widget.html()

    this.currentDate = new Date()
    this.referenceDate = this.currentDate

    this.$widget.html('')
    this.tick()

  tick: ->
    referenceTime = parseInt(this.referenceDate.getTime() / 1000)
    currentTime = parseInt(this.currentDate.getTime() / 1000)

    if referenceTime < currentTime
      increment = 900
    else if referenceTime > currentTime
      increment = 1100
    else
      increment = 1000

    this.currentDate = new Date(this.currentDate.getTime() + increment)
    this.referenceDate = new Date(this.referenceDate.getTime() + 1000)

    months = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember']
    weekdays = ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag']

    this.renderData({
      'time': {
        'hour': this.zeroPad(this.currentDate.getHours()),
        'minute': this.zeroPad(this.currentDate.getMinutes()),
        'second': this.zeroPad(this.currentDate.getSeconds())
      },
      'date': {
        'weekday': weekdays[this.currentDate.getDay()],
        'day': this.zeroPad(this.currentDate.getDate()),
        'month': months[this.currentDate.getMonth()],
        'year': this.zeroPad(this.currentDate.getFullYear())
      }
    })

    setTimeout (->
      _this.tick()
    ), increment

  zeroPad: (number) ->
    return '0' + number if number < 10
    number

  renderData: (data) ->
    this.render(this.template, data)

  render: (template, data) ->
    renderedTemplate = Mustache.render(template, data)
    this.$widget.html(renderedTemplate)

$(document).ready ->
  window.timeWidget = new TimeWidget()
