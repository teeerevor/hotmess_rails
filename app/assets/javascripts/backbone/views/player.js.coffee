READY = -1
ENDED = 0
PLAYING = 1
STOPPED = 2
BUFFERING = 3

DEFAULT = 0
CONTINUOUS = 1
SHUFFLE = 2
REPEAT = 3

class window.Hotmess.Views.PlayerView extends Backbone.View
  tagName: 'div'
  className: 'player'

  events:
    'click .play_pause' : 'play_pause'
    'click .next'       : 'next'
    'click .previous'   : 'previous'
    'click .shuffle'    : 'shuffle'
    'click .continuous' : 'continuous'

  initialize: ->
    @open_songs = {}
    @yt_players = {}
    @current_song_id = ''
    @player_mode = DEFAULT

  render: ->
    $(@el).html @template({})
    @

  template: (model) ->
    tp = Handlebars.compile($('#hottest-player-template').html())
    tp(model)

  open_song: (id, song) ->
    @open_songs[id] = song
    @current_song_id = id if @current_song_id == ''

  close_song: (id, song) ->
    @open_songs.delete[id]
    @yt_players.delete[id]

  yt_state_change: (player_id, player, state) ->
    console.log "yt_state_change #{state}"
    @yt_players[player_id] = player
    switch state
      when READY then @song_ready()
      when ENDED then @song_ended()
      when PLAYING then @song_playing(player_id)
      when STOPPED then @show_paused()
      when BUFFERING then @show_paused()

  song_ready: ->
    if @play_on_ready
      @play()
      @play_on_ready = false

  song_ended: ->
    switch @player_mode
      when CONTINUOUS then @next()
      when SHUFFLE then @shuffle_next()
        #stoa
      #when 'repeat'
        #stoeau
        #

  song_playing: (player_id) ->
    console.log 'song_playing'
    @pause() unless player_id == @current_song_id
    @set_current_song(player_id)
    @update_player_display()
    @show_playing()

  set_current_song: (id) ->
    console.log "current_song #{id}"
    @current_song_id = id

  current_song: ->
    console.log 'current_song'
    @open_songs[@current_song_id]

  current_song_name: ->
    @current_song().model.get('name')

  current_player: ->
    console.log 'current_player'
    @yt_players[@current_song_id]

  update_player_display: ->
    song = @current_song()
    window.tsong =  song
    @.$('.song_name').html(song.model.get('name'))
    @.$('.artist_name').html(song.model.get('artist').name)
    $('#app').addClass('active')

  play_pause: ->
    if $('.play_pause').hasClass('is_paused')
      @play()
    else
      @pause()

  play: ->
    console.log 'play'
    if @current_player()
      @current_player().playVideo()
    @show_playing()

  show_playing: ->
    console.log 'show play'
    track 'play', @current_song_name()
    $(@el).addClass('playing')
    $('.play_pause').addClass('is_playing')
    $('.play_pause').removeClass('is_paused')

  pause: ->
    console.log 'pause'
    if @current_player()
      @current_player().stopVideo()
    @show_paused()

  show_paused: ->
    console.log 'show paused'
    track 'pause', @current_song_name()
    $('.play_pause').removeClass('is_playing')
    $('.play_pause').addClass('is_paused')

  next: ->
    console.log 'next'
    track 'next', @current_song_name()
    next_song = songsList.get_next_song(@current_song().model)
    @pause()
    @current_song().close()
    next_song.trigger 'open'
    @set_current_song(next_song.get('youtube_url'))
    @update_player_display()
    @play_when_ready()

  previous: ->
    console.log 'prev'
    track 'prev', @current_song_name()
    next_song = songsList.get_previous_song(@current_song().model)
    @pause()
    @current_song().close()
    next_song.trigger 'open'
    @set_current_song(next_song.get('youtube_url'))
    @update_player_display()
    @play_when_ready()

  shuffle_next: ->
    console.log 'shuffle next'

  play_when_ready: ->
    @play_on_ready = true

  continuous: ->
    console.log 'continuous'
    track 'click', 'continuous'
    $('.continuous').toggleClass('active')
    $('.shuffle').removeClass('active')
    switch @player_mode
      #when CONTINUOUS then @player_mode = REPEAT
      #when REPEAT then @player_mode = DEFAULT
      when CONTINUOUS then @player_mode = DEFAULT
      else @player_mode = CONTINUOUS
    @show_player_mode()

  shuffle: ->
    console.log 'shuffle'
    switch @player_mode
      when SHUFFLE then @player_mode = DEFAULT
      else @player_mode = SHUFFLE
    @show_player_mode()

  show_player_mode: ->
    $('.shuffle').removeClass('active')
    $('.continuous').removeClass('active').removeClass('repeat')
    switch @player_mode
      when SHUFFLE then $('.shuffle').addClass('active')
      when CONTINUOUS then $('.continuous').addClass('active')
      when REPEAT then $('.continuous').addClass('repeat')


