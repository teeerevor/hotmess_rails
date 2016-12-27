window.Launcher = {
  init: ->
    @loadBackbone()
    #@shouldIShowApp()
    #@loadRestOfSongs() unless @hasLocalStorageSongs()
    $('.show-app').click ->
      Launcher.showApp()

    $('.animatescroll').click ->
      target = $(this).data('target')
      songListView.animateTo target

  shouldIShowApp: ->
    @showApp() if @hasLocalStorageSongs() || @hasShortlist()

  showApp: ->
    $('#app').removeClass('hidden')
    $('#react').removeClass('hidden')
    $('#loading').hide()

  loadBackbone: ->
    ReactDOM.render(React.createElement(App, {songs: gon.songs, artistSongs: gon.songs_by_artists}), document.getElementById("react"))
    #ReactDOM.render(React.createElement(App, {songs: gon.initial_songs}), document.getElementById("react"))
    ReactDOM.render(React.createElement(Player), document.getElementById("player"))

  hasShortlist: ->
    gon.shortlist
}
