SongAudio = React.createClass({
  render(){
    return (
      <div className='song-audio'>
        <div id={this.ytDivId()} />
        <div id='jjj-audio' />
      </div>
    );
  },
  componentWillMount: function() {
    thisPlayer = this;
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
      events: {
        'onReady': this.onPlayerReady,
        'onStateChange': this.onPlayerStateChange
      }
    });

    $('.song-audio').fitVids()
  },
  onPlayerReady: function(e){
    e.target.playVideo();
  },
  onPlayerStateChange: function(e){
    //BUFFERING: 3 CUED: 5 ENDED: 0 PAUSED: 2 PLAYING: 1 UNSTARTED: -1
    switch (e.data) {
      case YT.PlayerState.PLAYING:
        PubSub.publish( 'ytSongPlay', this.props.song);
        break;
      case YT.PlayerState.PAUSED:
        PubSub.publish( 'ytSongPause', this.props.song);
        break;
      case YT.PlayerState.ENDED:
        PubSub.publish( 'ytSongEnded', this.props.song);
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
    this.player.pauseVideo();
  },
  ytDivId: function(){
    return 'yt-video-'+this.props.song.youtube_url;
  }
})
