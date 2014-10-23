class window.Hotmess.Views.SongView extends Backbone.View
  className: 'song'

  events:
    'click .short_list_song'   : 'add_to_short_list'
    'click .short_list_to_pos' : 'add_to_short_list_at'
    'click .move_to_pos'       : 'move_to_top'
    'click .remove'            : 'remove_from_short_list'
    'click .song_details'      : 'toggle_song'
    'hover .song_header'       : 'toggle_song_highlight'

  initialize: ->
    @user_opened = false
    @song_open = false
    @model.bind 'open',  @open, @
    @model.bind 'close', @close, @
    @model.bind 'reset', @render, @
    @model.bind 'toggle', @toggle_song, @

  render: ->
    if @model
      $(@el).html(@template(@model.toJSON()))
      @setId()
      @setIndex()
      if not @model.is_playable()
        @set_unplayable()
      if @model.get('open')
        @toggle_song()
      if @model.get('added-song')
        @set_added_song()
    @

  template: (model)->
    Handlebars.registerHelper 'song_name_trim', (str)->
      if str and str.length > 37
        return str.substring(0,34) + '...'
      str

    tp = null
    if @model.sortedBy == 'artistName'
      tp = Handlebars.compile($('#song-artist-first-template').html())
    else
      tp = Handlebars.compile($('#song-template').html())
    tp(model)

  setId: ->
    $(@el).addClass "song-#{@model.get('id')}"

  setIndex: ->
    indexBaseStr = if @model.sortedBy == 'artistName' then @model.get('artistName') else @model.get('name')
    char = indexBaseStr.charAt 0
    unless songListView.charIsIndexed char
      songListView.setCharAsIndexed(char)
      $(@el).addClass char

  youtube_template: (model)->
    tp = Handlebars.compile($('#youtube-template').html())
    tp(model)

  add_to_short_list: ->
    window.shortList.add_to_shortlist @model
    @flash_song()
    track('click', 'add_to_short_list')
    #catch
      #show already in list error


  add_to_short_list_at: ->
    window.shortList.add_to_shortlist @model, {at: 0}
    @flash_song()
    track('click', 'add_to_short_list_at')
    #catch
      #show already in list error

  flash_song: ->
    song = @.$('.song_tab')
    desc = @.$('.song_extras')
    song.css('background-color', '#FCDB9A')
    desc.css('background-color', '#FCDB9A')
    setTimeout(->
      song.removeAttr('style')
      desc.removeAttr('style')
    , 200)

  toggle_song: ->
    @user_opened = if @user_opened then false else true
    if @song_open then @close() else @open()

  open: ->
    $(@el).addClass('expanded')
    yt_holder = @.$('.youtube_vid')
    if iOS
      @load_youtube_iframe(yt_holder, @model)
    else
      @load_youtube_swf(yt_holder, @model.get('youtube_url'))
    yt_holder.fitVids()
    @song_open = true
    track('click', 'open_song')

  close: ->
    unless @user_opened
      $(@el).removeClass('expanded')
      @.$('.youtube_vid').empty()
      @song_open = false
      track('click', 'close_song')

  load_youtube_iframe: (yt_contianer, model) ->
    yt_contianer.html(@youtube_template(model.toJSON()))

  load_youtube_swf: (yt_container, yt_vid_id) ->
    hottestPlayer.open_song(yt_vid_id, @)
    yt_container.append("<div id='#{yt_vid_id}'></div>")
    params = { allowScriptAccess: "always", wmode: "transparent" }
    atts = { id: yt_vid_id }
    url = "http://www.youtube.com/v/#{yt_vid_id}?enablejsapi=1&playerapiid=#{yt_vid_id}&version=3"
    swfobject.embedSWF(url, yt_vid_id, "610", "400", "8", null, null, params, atts)


  yt_player_stat_change: (state) ->
    console.log 'yt player state change'
    console.log 'event'

  toggle_song_highlight: ->
    $(@el).toggleClass('highlight')

  set_unplayable: ->
    $(@el).addClass('no-sound-assets')
