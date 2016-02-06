Player = React.createClass({
  render(){
    return(
      <div className='player is-paused'>
        {this.renderRandom()}
        {this.renderPlayer()}
      </div>
    );
  },
  renderRandom: function(){
    if(this.state.song.id == 0){
      return(
        <div className='play-random'>
          <button className='random circle-button' onClick={this.playRandom}>
            <InlineSvg iconClass={'icon-play'} iconName={'#play-circ'} />
          </button>
          <div className="i-feel-lucky">
            Fuck it, I feel lucky
          </div>
        </div>
      );
    }
  },
  renderPlayer: function(){
    //<InlineSvg iconClass={'icon-pause pause'} iconName={'#pause'} />
    if(this.state.song.id != 0){
      return(
        <div>
          <div className='current-song'>
            <b>{ this.state.song.name }</b>
            &nbsp;-&nbsp;
            { this.state.song.artistName }
        </div>
        <div className='player-buttons'>
          <button className='back small-button' onClick={this.back}>
            <InlineSvg iconClass={'icon-rewind'} iconName={'#rewind'} />
          </button>
          {this.renderPlayPause()}
          <button className='forward small-button' onClick={this.forward}>
            <InlineSvg iconClass={'icon-fastforward'} iconName={'#fastforward'} />
          </button>
          <button className='continuous small-button' onClick={this.continuous}>
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
      playing: false
    };
  },
  componentWillMount: function() {
    var player =  this
    this.pubsubPlay = PubSub.subscribe('ytSongPlay', function(topic, song) {
      player.setState({ playing: true, song: song });
    }.bind(this));
    this.pubsubPlay = PubSub.subscribe('ytSongPause', function(topic, song) {
      player.setState({ playing: false });
    }.bind(this));
  },
  componentWillUnmount: function() {
    PubSub.unsubscribe(this.pubsubPlay);
    PubSub.unsubscribe(this.pubsubPause);
    //PubSub.unsubscribe(this.pubsubMoveTop);
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
    this.setState({song: ['a']});
  },
  back: function(){
    console.log('back');
  },
  forward: function(){
    console.log('forward');
  },
  continuous: function(){
    console.log('continuous');
  }
});
