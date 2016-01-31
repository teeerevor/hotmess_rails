SongAudio = React.createClass({
  render(){
    return (
      <div className='song-audio'>
        <div id='yt-video' />
        <div id='jjj-audio' />
      </div>
    );
  },
  componentDidMount: function() {
    var videoId = this.props.song.youtube_url;
    var player;
    player = new YT.Player('yt-video', {
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
  }
})
