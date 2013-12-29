window.Hotmess =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Templates: {}

#delay 1000, -> something param
window.delay = (ms, func) -> setTimeout func, ms

window.resetableDelay = (->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
)()
