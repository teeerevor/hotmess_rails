AudioTrack = React.createClass({
  render(){
    return(
        <audio id={this.songId()}
              src={this.props.song.jjj_preview}
              className='jjj-audio'
              controls='false'
              onPlaying={this.playing}
              onPlay={this.playing}
              onPause={this.paused}
              onEnded={this.ended} >
        <p>Your browser does not support the <code>audio</code> element </p>
        </audio>
    );
  },
  componentWillMount: function() {
    var that = this;
    this.pubsubPlay = PubSub.subscribe('playerPlay', function(topic, song) {
      that.track().play();
    }.bind(this));
    this.pubsubPause = PubSub.subscribe('playerPause', function(topic) {
      that.track().pause();
    }.bind(this));
  },
  componentWillUnmount: function() {
    PubSub.unsubscribe(this.pubsubPlay);
    PubSub.unsubscribe(this.pubsubPause);
  },
  componentDidMount: function() {
    var that = this;
    //pause all corrent playing
    PubSub.publish( 'playerPause');
    setTimeout(function(){
      that.track().play();
    }, 500);
    PubSub.publish( 'songPlay', this.props.song);
  },
  playing: function(){
    PubSub.publish( 'songPlay', this.props.song);
  },
  paused: function(){
    PubSub.publish( 'songPause', this.props.song);
  },
  ended: function(){
    PubSub.publish( 'songEnded', this.props.song);
  },
  play: function(){
    this.track().play();
  },
  pause: function(){
    this.track().pause();
  },
  songId: function(){
    return 'song-' + this.props.song.id;
  },
  track: function(){
    return document.getElementById(this.songId());
  }
})
