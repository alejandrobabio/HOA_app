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
    startData = JSON.parse @gapi.hangout.getStartData()

    console.log startData

    callbackUrl = startData.callbackUrl + startData.hangoutId

    hangoutUrl = @gapi.hangout.getHangoutUrl()
    youTubeLiveId = @gapi.hangout.onair.getYouTubeLiveId()
    participants = @gapi.hangout.getParticipants()
    isBroadcasting = @gapi.hangout.onair.isBroadcasting()

    $.ajax {
      url: callbackUrl,
      dataType: 'text',
      type: 'PUT',
      data:
        title: startData.title,
        project_id: startData.projectId,
        event_id: startData.eventId,
        category: startData.category,
        host_id: startData.hostId,
        participants: participants,
        hangout_url: hangoutUrl,
        yt_video_id: youTubeLiveId,
        status: @status,
        notify: true
      success: ->
        @gapi.hangout.data.setValue('status', 'ok')
        $('#main').append "<p>ajax return: success</p>"

        if @gapi.hangout.data.getValue('updated') != 'true'
          @gapi.hangout.layout.displayNotice 'Connection to WebsiteOne established'
          @gapi.hangout.data.setValue 'updated', 'true'
      error: ->
        @gapi.hangout.data.setValue 'status', 'error'
        $('#main').append "<p>ajax return: error</p>"
      }

  send_interval: ->
    console.log @gapi.hangout.onair
    console.log @gapi.hangout.onair.isBroadcasting()
    $('#main').append "<p>10 sec, Broadcasting: #{@gapi.hangout.onair.isBroadcasting()}</p>"

$ ->
  gadgets.util.registerOnLoadHandler(new Hangout(gapi))
