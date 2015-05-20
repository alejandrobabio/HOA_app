class Hangout
  constructor: (@gapi) ->
    @status = 'started'
    @gapi.hangout.onApiReady.add =>
      @gapi.hangout.onair.onBroadcastingChanged.add @changeStatus
    setInterval @send_interval, 10000
    @notify()

  changeStatus: (e) ->
    console.log "Status: #{@status}"

    prev_status = @status
    if e.isBroadcasting
      @status = 'broadcasting' if @status is 'started'
    else
      @status = 'finished' if @status is 'broadcasting'
    if prev_status isnt @status
      $('#main').append "<p>change status: #{@status}</p>"
      @notify()

  notify: =>
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
        hoa_status: @status,
        notify: true
      success: ->
        console.log 'ajax.success'
        @gapi.hangout.data.setValue('status', 'ok')
        $('#main').append "<p>ajax return: success</p>"

        if @gapi.hangout.data.getValue('updated') != 'true'
          @gapi.hangout.layout.displayNotice 'Connection to WebsiteOne established'
          @gapi.hangout.data.setValue 'updated', 'true'
      error: ->
        console.log 'ajax.error'
        @gapi.hangout.data.setValue 'status', 'error'
        $('#main').append "<p>ajax return: error</p>"
      }

  send_interval: ->
    $('#main').append "<p>2 minutes, Broadcasting: #{@gapi.hangout.onair.isBroadcasting()}</p>"
    @notify()

$ ->
  gadgets.util.registerOnLoadHandler(new Hangout(gapi))
