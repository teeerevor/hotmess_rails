window.track = (event, label) ->
  #console.log "user = #{window.user}"
  #console.log "event = #{event}"
  #console.log "label = #{label}"
  _gaq.push(['_trackEvent', window.user, event, label])

$ ->
  #tracks what song canditdates index buttons are clicked
  $('.list_index a').click (e) ->
    letterClicked = $(e.target).text().trim()
    track('index_click', letterClicked)
