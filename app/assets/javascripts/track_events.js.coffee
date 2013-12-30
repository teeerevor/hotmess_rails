window.track = (event, label) ->
  #console.log "user = #{window.user}"
  #console.log "event = #{event}"
  #console.log "label = #{label}"
  _gaq.push(['_trackEvent', window.user, event, label])
