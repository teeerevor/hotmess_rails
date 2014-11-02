class window.Hotmess.Collections.Songs extends Backbone.Collection
  model: Hotmess.Models.Song
  name: 'songs'
  sortedBy: 'songName'

  storeName: 'songs'
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

class window.Hotmess.Collections.ShortList extends Hotmess.Collections.Songs #Backbone.Collection
  name: 'short_list'
  remoteUrl: '/short_lists/'
  local: true
  storeName: 'shortlist'
  comparator: 'shortlistPosition'

  setRemoteUrl: (email) ->
    @email = email
    @url = "#{@remoteUrl}#{email}"

  saveList: (email) ->
    @saveLocally()
    @setRemoteUrl(email) if email
    if @email
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

  saveLocally: ->
    for model, i in shortList.models
      model.set('shortlistPosition', i)
      model.save()
