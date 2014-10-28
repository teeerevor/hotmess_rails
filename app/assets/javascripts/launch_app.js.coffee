window.App = {
  init: ->
    self = @

    App.showApp() if gon.shortlist
    self.loadBackbone()
    self.loadRestOfSongs()

    $('.toggle-sort-button').click ->
      sortedBy = songsList.sortedBy
      $(this).find('.label').text(self.buttonLabel(sortedBy))
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

  buttonLabel: (option) ->
    if option == 'songName'
      return 'song'
    else
      return 'artist'

  showApp: ->
    $('#app').removeClass('hidden')
    $('.list_index').removeClass('hidden')
    $('#loading').hide()

  loadBackbone: ->
    #year and email are set in the app layout

    #window.songsList = new Hotmess.Collections.Songs(gon.songs)
    window.songsList = new Hotmess.Collections.Songs(gon.initial_songs)
    window.songListView = new Hotmess.Views.SongsListView({collection: songsList})
    $('#song_list').append(songListView.render().el)

    window.saveLoadView = new Hotmess.Views.SaveLoadView({})
    $('header').append(saveLoadView.render().el)
    saveLoadView.setEmailFromUrlLoad(urlEmail) if urlEmail

    window.hottestPlayer = new Hotmess.Views.PlayerView({})
    $('header').append(hottestPlayer.render().el)

    #load these last - will break url email to saveload push otherwise
    sl = []
    sl = gon.shortlist if gon.shortlist
    window.shortList = new Hotmess.Collections.ShortList(sl, {year: urlYear, email: urlEmail})
    window.shortListView = new Hotmess.Views.ShortListView({collection: shortList})
    $('#short_list').append(shortListView.render().el)

    window.user = if urlEmail then urlEmail else 'anonymous'

  loadSong: (song, timeout) ->
    setTimeout ->
      console.log 'loading...'
      songsList.add(song)
    , timeout

  loadRestOfSongs: ->
    @loadSong song, i for song, i in gon.songs #loads each song after waiting a millsecond

  loadFromLocalStorage: ->
    window.songsList = new Hotmess.Collections.Songs()
    songsList.fetch()
}

$ ->
  App.init()
