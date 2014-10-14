class window.Hotmess.Views.SongsListView extends Backbone.View
  tagName:    'ol'
  className:  'song_list'

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'sort',  @render, @
    @collection.bind 'add',   @addSong, @

  render: ->
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

  updateTotal: (song_count) ->
    h2 = $(@el).parent().find('h2')
    text = h2.text().split('-')[0]
    songs_text = ''

    if song_count > 0
      text = text + " - #{song_count} song#{ if song_count > 1 then 's' else ''}"

    h2.text(text)

class window.Hotmess.Views.ShortListView extends Hotmess.Views.SongsListView
  className:  'short_list'

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'add', @addSong, @
    @collection.bind 'remove', @render, @

  render: ->
    @tryBlankState()
    super

  addSong: (song) ->
    @updateTotal(@collection.length)
    @tryBlankState()
    songView = new Hotmess.Views.SongView({model: song, className: 'song added-song'})

    if @collection.indexOf(song) == 0
      @addSongToTop(songView)
    else
      @addSongToBottom(songView)

  addSongToTop: (songView) ->
    $(@el).prepend songView.render().el

  addSongToBottom: (songView) ->
    $(@el).append songView.render().el

  tryBlankState: ->
    if @collection.length == 0
      @showBlankState()
    else
      @hideBlankState()

  showBlankState: ->
    $('.empty_list_blank_state').show()

  hideBlankState: ->
    $('.empty_list_blank_state').hide()

