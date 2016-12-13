YoutubeTrack = React.createClass({
  render(){
    let ytId = this.ytDivId()
    return( <div id={ytId} /> );
  },
  componentWillMount: function() {
    var thisPlayer = this;
    this.pubsubPlay = PubSub.subscribe('playerPlay', function(topic, song) {
      thisPlayer.play(song);
    }.bind(this));
    this.pubsubPause = PubSub.subscribe('playerPause', function(topic) {
      thisPlayer.pause();
    }.bind(this));
  },
  componentWillUnmount: function() {
    PubSub.unsubscribe(this.pubsubPlay);
    PubSub.unsubscribe(this.pubsubPause);
    this.player.destroy();
    delete player;
  },
  componentDidMount: function() {
    var videoId = this.props.song.youtube_url;
    var divId = this.ytDivId();
    this.player = new YT.Player(divId, {
      videoId: videoId,
      playerVars: { 'autoplay': 1},
      events: {
        'onStateChange': this.onPlayerStateChange
      }
    });

    PubSub.publish( 'playerPause');
    $('.song-audio').fitVids()
  },
  onPlayerStateChange: function(e){
    //BUFFERING: 3 CUED: 5 ENDED: 0 PAUSED: 2 PLAYING: 1 UNSTARTED: -1
    switch (e.data) {
      case YT.PlayerState.PLAYING:
        PubSub.publish( 'songPlay', this.props.song);
        break;
      case YT.PlayerState.PAUSED:
        PubSub.publish( 'songPause', this.props.song);
        break;
      case YT.PlayerState.ENDED:
        PubSub.publish( 'songEnded', this.props.song);
        break;
    }
  },
  play: function(song){
    if(this.props.song.id === song.id)
      this.player.playVideo();
    else
      this.player.pauseVideo();
  },
  pause: function(){
    if(this.player.pauseVideo){
      this.player.pauseVideo();
    }
  },
  ytDivId: function(){
    return 'yt-video-'+this.props.song.youtube_url;
  }
})
