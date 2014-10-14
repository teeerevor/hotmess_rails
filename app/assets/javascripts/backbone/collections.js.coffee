class window.Hotmess.Collections.Songs extends Backbone.Collection
  url: '/songs/'
  model: Hotmess.Models.Song
  name: 'songs'
  sortedBy: 'songName'

  localStorage: new Backbone.LocalStorage("hottest100ioStore")

  sortStrategies:
    name:        (song) ->  return song.get 'name'
    artistName:  (song) ->  return song.get 'artistName'

  toggleListSort: ->
    if @sortedBy == 'songName'
      @comparator = @sortStrategies['artistName']
      @sortedBy = 'artistName'
    else
      @comparator = @sortStrategies['name']
      @sortedBy = 'songName'
    @sort()
    return @sortedBy

  save: ->
    for model in @models
      model.save()

  get_next_song: (song) ->
    song_index = _.indexOf( @models, song)
    @.models[song_index + 1]

  get_previous_song: (song) ->
    song_index = _.indexOf( @models, song)
    @.models[song_index - 1]

class window.Hotmess.Collections.ShortList extends Hotmess.Collections.Songs
  url: '/short_lists/'
  name: 'short_list'

  setListUrl: (email) ->
    @url = "/short_lists/#{email}"

  saveList: (email) ->
    @setListUrl(email)
    $.post(@url, {songs: @.pluck('id')})

  loadList: (email) ->
    @setListUrl(email)
    @fetch({
        success: -> saveLoadView.updateUrl(),
        error: -> saveLoadView.resetToBlank()
    })

  loadListFromUrlEmail: (email) ->
    @setListUrl(email)
    @fetch({success: -> saveLoadView.setEmailFromUrlLoad(email)})

  add_to_shortlist: (model, options) ->
    #set so that view knows not to add to index
    model.set 'short_list', true
    @add(model, options)
