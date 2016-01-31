Player = React.createClass({
  render(){
    return(
      <div className='player is-paused'>
        {this.displayRandom()}
        {this.displayPlayer()}
      </div>
    );
  },
  displayRandom: function(){
    if(this.state.song.length == 0){
      return(
        <div className='play-random'>
          <button className='random' onClick={this.playRandom}>
            <InlineSvg iconClass={'icon-play'} iconName={'#play'} />
          </button>
          <div className="i-feel-lucky">
            Fuck it, I feel lucky
          </div>
        </div>
      );
    }
  },
  displayPlayer: function(){
    //<InlineSvg iconClass={'icon-pause pause'} iconName={'#pause'} />
    if(this.state.song.length > 0){
      return(
      <div>
        <div className='current-song'>
            <b>Song Name</b>
            &nbsp;-&nbsp;
            Artist Name
        </div>
        <div className='player-buttons'>
          <button className='back' onClick={this.back}>
            <InlineSvg iconClass={'icon-rewind'} iconName={'#rewind'} />
          </button>
          <button className='play-pause' onClick={this.togglePlay}>
            <InlineSvg iconClass={'icon-play play'} iconName={'#play'} />
          </button>
          <button className='forward' onClick={this.forward}>
            <InlineSvg iconClass={'icon-fastforward'} iconName={'#fastforward'} />
          </button>
          <button className='continuous' onClick={this.continuous}>
            <InlineSvg iconClass={'icon-continuous'} iconName={'#continue'} />
          </button>
        </div>
        </div>
      );
    }
  },
  getInitialState: function(){
    return {
      song: [],
    };
  },
  showSong: function(){
  },
  playRandom: function(){
    this.setState({song: ['a']});
  },
  back: function(){
    console.log('back')
  },
  forward: function(){
    console.log('forward')
  },
  togglePlay: function(){
    console.log('togglePlay')
  },
  continuous: function(){
    console.log('continuous')
  }
});
