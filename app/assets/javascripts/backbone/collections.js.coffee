class window.Hotmess.Collections.Songs extends Backbone.Collection
  url: '/songs/'
  model: Hotmess.Models.Song
  name: 'songs'

  initialize: ->
    if options = arguments[1]
      @email = options['email']
      @year = options['year']

      unless @year== ''
        if @url == '/songs/'
          @url = "/songs/#{@year}"

  get_next_song: (song) ->
    song_index = _.indexOf( @.models, song)
    @.models[song_index + 1]

  get_previous_song: (song) ->
    song_index = _.indexOf( @.models, song)
    @.models[song_index - 1]

class window.Hotmess.Collections.ShortList extends Hotmess.Collections.Songs
  url: '/short_lists/'
  name: 'short_list'

  initialize: ->
    super

    unless @email == ''
      @loadListFromUrlEmail(@email)

  setListUrl: (email) ->
    @url = "/short_lists/#{email}"

  saveList: (email) ->
    @setListUrl(email)
    $.post(@url, {songs: @.pluck('id')})

  loadList: (email) ->
    @setListUrl(email)
    @fetch({success: -> saveLoadView.updateUrl()})

  loadListFromUrlEmail: (email) ->
    @setListUrl(email)
    @fetch({success: -> saveLoadView.setEmailFromUrlLoad(email)})
