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
    'click .play-random' : 'playRandomSong'
    'click .play_pause'  : 'playPause'
    'click .next'        : 'next'
    'click .previous'    : 'previous'
    'click .shuffle'     : 'shuffle'
    'click .continuous'  : 'continuous'
    'click .current_song': 'showCurrentSong'

  initialize: ->
    @openSongs = {}
    @ytPlayers = {}
    @currentSongId = ''
    @playerMode = DEFAULT
    @isPlaying = false

  render: ->
    $(@el).html @template({})
    @

  template: (model) ->
    tp = Handlebars.compile($('#hottest-player-template').html())
    tp(model)

  openPlayer: (playerId, song) ->
    @openSongs[playerId] = song
    @currentSongId = playerId if @currentSongId == ''

  closePlayer: (playerId) ->
    delete @openSongs[playerId]
    delete @ytPlayers[playerId]

  ytStateChange: (playerId, player, state) ->
    console.log "ytStateChange - #{state}"
    @ytPlayers[playerId] = player
    switch state
      when READY then @songReady(playerId)
      when ENDED then @songEnded()
      when PLAYING then @songPlaying(playerId)
      when STOPPED then @showPaused()
      when BUFFERING then @showPaused()

  songReady: (playerId) ->
    console.log "ready playerId=#{playerId}"
    @setCurrentSongFromId(playerId)
    if @playOnReady
      @play()
      @playOnReady = false

  songEnded: ->
    switch @playerMode
      when CONTINUOUS then @next()
      when SHUFFLE then @shuffleNext()
        #stoa
      #when 'repeat'
        #stoeau
        #

  songPlaying: (playerId) ->
    console.log 'songPlaying'
    @setCurrentSongFromId(playerId)
    #@pauseOtherSongs()
    @updatePlayerDisplay(@currentSongModel)
    @showPlaying()

  setCurrentSongFromId: (playerId) ->
    console.log 'setCurrentSongFromId'
    @currentSongId = playerId
    @currentSong = @openSongs[playerId]
    @currentSongModel = @currentSong.model

  setCurrentSong: (song) ->
    @currentSong = song
    @currentSongModel = song.model

  currentSongName: ->
    @currentSongModel.get('name')

  currentPlayer: ->
    @ytPlayers[@currentSongId]

  updatePlayerDisplay: (model) ->
    console.log 'updatePlayerDisplay'
    @.$('.song_name').html(model.get('name'))
    @.$('.artist_name').html(model.get('artist').name)
    $('#app').addClass('active')

  playPause: ->
    if @isPlaying
      @pause()
    else
      @play()

  play: ->
    console.log 'play'
    $('i-feel-lucky').remove()
    @swapRandomToPlay()
    if @currentPlayer()
      @currentPlayer().playVideo()
      @isPlaying = true
    @showPlaying()
    track 'play', @currentSongName()

  swapRandomToPlay: ->
    $('.play-random').removeClass('play-random').addClass('play_pause').addClass('is_paused')

  playRandomSong: ->
    song = _.sample(songsList.models)
    @swapRandomToPlay()
    @readySongForPlaying(song)

  showPlaying: ->
    console.log 'show play'
    $(@el).addClass('playing')
    $('.play_pause').addClass('is_playing')
    $('.play_pause').removeClass('is_paused')

  pause: ->
    console.log 'pause'
    if @currentPlayer()
      @currentPlayer().stopVideo()
      @isPlaying = false
    @showPaused()

  pauseOtherSongs: ->
    for id, player in @ytPlayers
      unless id == @currentSongId
        player.pause()


  showPaused: ->
    console.log 'show paused'
    track 'pause', @currentSongName()
    $('.play_pause').removeClass('is_playing')
    $('.play_pause').addClass('is_paused')

  next: ->
    console.log 'next'
    track 'next', @currentSongName()
    nextSong = songsList.getNextSong(@currentSongModel)
    @pause()
    @currentSong.trigger 'close'
    @setCurrentSong(nextSong)
    @readySongForPlaying(nextSong)

  previous: ->
    console.log 'prev'
    track 'prev', @currentSongName()
    nextSong = songsList.getPreviousSong(@currentSongModel)
    @pause()
    @currentSong.trigger 'close'
    @setCurrentSong(nextSong)
    @readySongForPlaying(nextSong)

  readySongForPlaying: (song) ->
    song.trigger 'open'
    songListView.animateToSong song
    @updatePlayerDisplay(song)
    @playWhenReady()

  shuffleNext: ->
    console.log 'shuffle next'

  playWhenReady: ->
    @playOnReady = true

  continuous: ->
    console.log 'continuous'
    track 'click', 'continuous'
    $('.continuous').toggleClass('active')
    $('.shuffle').removeClass('active')
    switch @playerMode
      #when CONTINUOUS then @playerMode = REPEAT
      #when REPEAT then @playerMode = DEFAULT
      when CONTINUOUS then @playerMode = DEFAULT
      else @playerMode = CONTINUOUS
    @showPlayerMode()

  shuffle: ->
    console.log 'shuffle'
    switch @playerMode
      when SHUFFLE then @playerMode = DEFAULT
      else @playerMode = SHUFFLE
    @showPlayerMode()

  showPlayerMode: ->
    $('.shuffle').removeClass('active')
    $('.continuous').removeClass('active').removeClass('repeat')
    switch @playerMode
      when SHUFFLE then $('.shuffle').addClass('active')
      when CONTINUOUS then $('.continuous').addClass('active')
      when REPEAT then $('.continuous').addClass('repeat')

  showCurrentSong: ->
    songListView.animateToSong(@currentSongModel)


