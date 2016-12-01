App.widget_data = App.cable.subscriptions.create channel: 'WidgetDataChannel', widget: 'time',
  connected: ->
    console.log('time connected')

  disconnected: ->
    console.log('time disconnected')

  received: (data) ->
    console.log('time received data:', data)
    window.timeWidget.referenceDate = new Date(data)

class TimeWidget

  _this = undefined

  constructor: ->
    _this = this

    this.$widget = $('.widget > .time')
    this.template = this.$widget.html()

    this.months = this.$widget.data('months')
    this.weekdays = this.$widget.data('weekdays')

    this.currentDate = new Date()
    this.referenceDate = this.currentDate

    this.$widget.html('')
    this.tick()

  tick: ->
    referenceTime = parseInt(this.referenceDate.getTime() / 1000)
    currentTime = parseInt(this.currentDate.getTime() / 1000)
    difference = referenceTime - currentTime

    if Math.abs(difference) > 10
      this.currentDate = this.referenceDate

    if difference == 0
      increment = 1000
    else if difference < 0
      increment = 900
    else if difference > 0
      increment = 1100

    this.currentDate = new Date(this.currentDate.getTime() + increment)
    this.referenceDate = new Date(this.referenceDate.getTime() + 1000)

    this.renderData({
      'time': {
        'hour': this.zeroPad(this.currentDate.getHours()),
        'minute': this.zeroPad(this.currentDate.getMinutes()),
        'second': this.zeroPad(this.currentDate.getSeconds())
      },
      'date': {
        'weekday': this.weekdays[this.currentDate.getDay()],
        'day': this.zeroPad(this.currentDate.getDate()),
        'month': this.months[this.currentDate.getMonth()],
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
