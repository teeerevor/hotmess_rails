class window.Hotmess.Views.SongsListView extends Backbone.View
  className: 'song_list'
  charIndex:  {}

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'sort',  @render, @
    @collection.bind 'add',   @addSong, @

  render: ->
    @charIndex = {}
    $(@el).empty()
    container = document.createDocumentFragment()
    for song in @collection.models
      song.sortedBy = @collection.sortedBy
      songView = new Hotmess.Views.SongView({model: song})
      container.appendChild songView.render().el
    $(@el).append(container)
    @

  addSong: (song) ->
    songView = new Hotmess.Views.SongView({model: song})
    $(@el).append(songView.render().el)
    @

  toggleSong: (@model) ->
    @animateToSong @model
    @collection.get(@model).trigger 'toggle'

  animateToSong: (@model) ->
    target = ".song-#{@model.get 'id' }"
    @animateTo target

  animateTo: (target) ->
    $(target).animatescroll
      element:'#song_list'
      padding:10
      scrollSpeed:2000
      easing:'easeInOutCubic'

  charIsIndexed: (char) ->
    @charIndex[char]

  setCharAsIndexed: (char) ->
    @charIndex[char] = true


class window.Hotmess.Views.ShortListView extends Hotmess.Views.SongsListView
  className:  'shortlist'

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'add', @addSong, @
    @collection.bind 'remove', @render, @

  render: ->
    @updateTotal(@collection.length)
    @tryBlankState()
    if @collection.length > 0
      $(@el).empty()
      container = document.createDocumentFragment()
      for song in @collection.models
        songView = new Hotmess.Views.ShortListSongView({model: song, className: 'shortlist-song'})
        container.appendChild songView.render().el
      $(@el).append(container)
    @

  addSong: (song) ->
    @updateTotal(@collection.length)
    @tryBlankState()
    songView = new Hotmess.Views.ShortListSongView({model: song, className: 'shortlist-song added-song'})

    if @collection.indexOf(song) == 0
      @addSongToTop(songView)
    else
      @addSongToBottom(songView)

  addSongToTop: (songView) ->
    $(@el).prepend songView.render().el
    setTimeout ->
      $(songView.el).removeClass('added-song')
    , 400

  addSongToBottom: (songView) ->
    $(@el).append songView.render().el
    setTimeout ->
      $(songView.el).removeClass('added-song')
    , 400

  updateTotal: (song_count) ->
    h2 = $(@el).parent().find('h2')
    text = h2.text().split('-')[0]
    songs_text = ''

    if song_count > 0
      text = text + " - #{song_count} song#{ if song_count > 1 then 's' else ''}"

    h2.text(text)

  tryBlankState: ->
    if @collection.length == 0
      @showBlankState()
    else
      @hideBlankState()

  showBlankState: ->
    $('.empty_list_blank_state').show()

  hideBlankState: ->
    $('.empty_list_blank_state').hide()

