class window.Hotmess.Collections.Songs extends Backbone.Collection
  model: Hotmess.Models.Song
  name: 'songs'
  sortedBy: 'songName'

  url: 'songs'
  local: true

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
    @

  save: ->
    for model in @models
      model.save()

  get_next_song: (song) ->
    song_index = _.indexOf( @models, song)
    @models.at song_index + 1

  get_previous_song: (song) ->
    song_index = _.indexOf( @models, song)
    @models.at song_index - 1

class window.Hotmess.Collections.ShortList extends Backbone.Collection
  name: 'short_list'
  url: 'shortlist'
  localUrl: 'shortlist'
  remoteUrl: '/short_lists/'
  local: true

  setLocalUrl: ->
    @url = @localUrl

  setRemoteUrl: (email) ->
    @url = "#{remoteUrl}#{email}"

  saveList: (email) ->
    @setRemoteUrl(email)
    $.post(@url, {songs: @.pluck('id')})

  loadList: (email) ->
    @setRemoteUrl(email)
    @fetch({
        success: -> saveLoadView.updateUrl(),
        error: -> saveLoadView.resetToBlank()
    })

  loadListFromUrlEmail: (email) ->
    @setRemoteUrl(email)
    @fetch({success: -> saveLoadView.setEmailFromUrlLoad(email)})

  #add: (model, options) ->
    #model.collection = @
    #super(model, options)
    #if model.id
      #console.log 'save'
      #@localSync()

  #remove: (model) ->
    #super(model)
    #@localSync()
