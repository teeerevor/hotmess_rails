window.Launcher = {
  init: ->
    @loadBackbone()
    @shouldIShowApp()
    #@loadRestOfSongs() unless @hasLocalStorageSongs()
    $('.show-app').click ->
      Launcher.showApp()

    $('.toggle-sort-button').click ->
      sortedBy = songsList.sortedBy
      $(this).find('.label').text(App.buttonLabel(sortedBy))
      $('.song_list').empty()
      $('.loader').show()
      setTimeout ->
        songsList.toggleListSort()
        $('.loader').hide()
      , 100

    $('.animatescroll').click ->
      target = $(this).data('target')
      songListView.animateTo target


    #saves shortlist when window closes
    #$(window).unload ->
      #shortList.saveList()

  shouldIShowApp: ->
    @showApp() if @hasLocalStorageSongs() || @hasShortlist()

  showApp: ->
    $('#app').removeClass('hidden')
    $('#react').removeClass('hidden')
    $('#loading').hide()

  loadBackbone: ->
    #year and email are set in the app layout
    #if @hasLocalStorageSongs()
      #window.songsList = new Hotmess.Collections.Songs([])
      #songsList.fetch()
    #else
      #window.songsList = new Hotmess.Collections.Songs()
      #load the rest later
    ReactDOM.render(React.createElement(App, {songs: gon.songs, artistSongs: gon.songs_by_artists}), document.getElementById("react"))
    #ReactDOM.render(React.createElement(App, {songs: gon.initial_songs}), document.getElementById("react"))
    ReactDOM.render(React.createElement(Player), document.getElementById("player"))

    #$('header').append(saveLoadView.render().el)
    #saveLoadView.setEmailFromUrlLoad(urlEmail) if urlEmail

    #load these last - will break url email to saveload push otherwise
    #if gon.shortlist
      #window.shortList = new Hotmess.Collections.ShortList(gon.shortlist, {year: urlYear, email: urlEmail})
    #else
      #window.shortList = new Hotmess.Collections.ShortList([], {year: urlYear, email: urlEmail})
      #shortList.fetch()
    #window.shortListView = new Hotmess.Views.ShortListView({collection: shortList})
    #$('#short_list').append(shortListView.render().el)

    window.user = if urlEmail then urlEmail else 'anonymous'

  loadSong: (song, timeout) ->
    setTimeout ->
      console.log 'loading...'
      songsList.add(song)
    , timeout

  loadRestOfSongs: ->
    @loadSong song, i for song, i in gon.songs #loads each song after waiting a millsecond
    if @hasLocalStorage()
      #saves songs to local storage once complete
      localStorage.clear()
      localStorage.setItem('year', urlYear)
      setTimeout ->
        songsList.save()
      , gon.songs.length + 5

  hasShortlist: ->
    gon.shortlist

  hasLocalStorageSongs: ->
    @hasLocalStorage() && localStorage.getItem('year') == urlYear &&  localStorage.getItem('songs')

  hasLocalStorage: ->
    Modernizr.localstorage
}
