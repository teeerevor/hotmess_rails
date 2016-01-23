window.Launcher = {
  init: ->
    @shouldIShowApp()
    @loadBackbone()
    #@loadRestOfSongs() unless @hasLocalStorageSongs()

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

    $('.show-app').click ->
      App.showApp()

    $(window).unload ->
      shortList.saveList()

  shouldIShowApp: ->
    @showApp() if @hasLocalStorageSongs() || @hasShortlist()

  showApp: ->
    $('#app').removeClass('hidden')
    $('.list_index').removeClass('hidden')
    $('#loading').hide()

  loadBackbone: ->
    #year and email are set in the app layout
    #if @hasLocalStorageSongs()
      #window.songsList = new Hotmess.Collections.Songs([])
      #songsList.fetch()
    #else
      #window.songsList = new Hotmess.Collections.Songs()
      #load the rest later

    ReactDOM.render(React.createElement(App, {songs: gon.initial_songs}), document.getElementById("react"))
    #window.songListView = new Hotmess.Views.SongsListView({collection: songsList})

    #$('header').append(saveLoadView.render().el)
    #saveLoadView.setEmailFromUrlLoad(urlEmail) if urlEmail

    #window.hottestPlayer = new Hotmess.Views.PlayerView({})
    #$('header').append(hottestPlayer.render().el)

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

$ ->
  Launcher.init()
