Player = React.createClass({
  render(){
    var classes = ['player'];
    if(this.state.continuousPlay)
      classes.push('continuousPlay');
    return(
      <div className={classes.join(' ')}>
        {this.renderRandom()}
        {this.renderPlayer()}
      </div>
    );
  },
  renderRandom: function(){
    if(this.state.song.id == 0){
      return(
        <div className='player-random'>
          <button className='random circle-button' onClick={this.playRandom}>
            <InlineSvg iconClass={'icon-play'} iconName={'#play-circ'} />
          </button>
          <div className="i-feel-lucky">
            Fuck it play something
          </div>
        </div>
      );
    }
  },
  renderPlayer: function(){
    if(this.state.song.id != 0){
      return(
        <div className='player-display'>
          <div className='current-song'>
            <b>{ this.state.song.name }</b>
            { this.state.song.artistName }
          </div>
          <div className='player-buttons'>
            <button className='back small-button' onClick={this.previous}>
              <InlineSvg iconClass={'icon-rewind'} iconName={'#rewind'} />
            </button>
            {this.renderPlayPause()}
            <button className='forward small-button' onClick={this.next}>
              <InlineSvg iconClass={'icon-fastforward'} iconName={'#fastforward'} />
            </button>
            <button className='continuous small-button' onClick={this.continuousToggle}>
              <InlineSvg iconClass={'icon-continuous'} iconName={'#continue'} />
            </button>
          </div>
        </div>
      );
    }
  },
  renderPlayPause: function(){
    if(this.state.playing){
      return(
          <button className='pause circle-button' onClick={this.pause}>
            <InlineSvg iconClass={'icon-pause'} iconName={'#pause-circ'} />
          </button>
      );
    }else{
      return(
        <button className='play circle-button' onClick={this.play}>
          <InlineSvg iconClass={'icon-play'} iconName={'#play-circ'} />
        </button>
      );
    }
  },
  getInitialState: function(){
    return {
      song: {id:0},
      playing: false,
      continuousPlay: false
    };
  },
  componentWillMount: function() {
    var player =  this
    this.pubsubPlay = PubSub.subscribe('ytSongPlay', function(topic, song) {
      player.setState({ playing: true, song: song });
    }.bind(this));
    this.pubsubPause = PubSub.subscribe('ytSongPause', function(topic, song) {
      player.setState({ playing: false });
    }.bind(this));
    this.pubsubSongEnd = PubSub.subscribe('ytSongEnded', function(topic, song) {
      if(player.state.continuousPlay)
        player.next();
    }.bind(this));
    this.pubsubUpdateSong = PubSub.subscribe('updateCurrentSong', function(topic, song) {
      player.setState({ playing: false, song: song });
    }.bind(this));
  },
  componentWillUnmount: function() {
    PubSub.unsubscribe(this.pubsubPlay);
    PubSub.unsubscribe(this.pubsubPause);
    PubSub.unsubscribe(this.pubsubEnd);
    PubSub.unsubscribe(this.pubsubUpdateSong);
  },
  play: function(){
    this.setState({ playing: true });
    PubSub.publish( 'playerPlay', this.state.song);
  },
  pause: function(){
    this.setState({ playing: false });
    PubSub.publish( 'playerPause');
  },
  playRandom: function(){
    PubSub.publish( 'playerRandom');
  },
  previous: function(){
    PubSub.publish( 'playerPrevious', this.state.song);
  },
  next: function(){
    PubSub.publish( 'playerNext', this.state.song);
  },
  continuousToggle: function(){
    var state = this.state.continuousPlay ? false : true;
    this.setState({continuousPlay: state});
  }
});
