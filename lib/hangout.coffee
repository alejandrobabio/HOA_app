class Hangout
  constructor: (@gapi) ->
    @status = 'started'
    @gapi.hangout.onApiReady.add =>
      @gapi.hangout.onair.onBroadcastingChanged.add @changeStatus
    setInterval @send_interval, 10000

  changeStatus: (e) =>
    prev_status = @status
    if e.isBroadcasting
      @status = 'broadcasting' if @status is 'started'
    else
      @status = 'finished' if @status is 'broadcasting'
    @notify() if prev_status isnt @status

  notify: =>
    $('#main').append "<p>change status: #{@status}</p>"

  send_interval: ->
    console.log @gapi.hangout.onair
    $('#main').append '<p>10 sec</p>'

$ ->
  gadgets.util.registerOnLoadHandler(new Hangout(gapi))
