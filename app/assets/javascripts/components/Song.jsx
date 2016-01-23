Song = React.createClass({
  render() {
    const songClassName = false ? "opened" : "";

    return (
      <li className={'song '+songClassName}>
        <div className='song-display' onClick={this.toggleDisplay}>
          {this.arrangeSongInfo()}
          {this.addWaypoint()}
          {this.addAudio()}
        </div>
        <button onClick={this.shortlistTop} > <InlineSvg iconClass={'icon-top'} iconName={'#up-arrow'} /> </button>
        <button onClick={this.shortlistAdd} > <InlineSvg iconClass={'icon-plus'} iconName={'#plus'} /> </button>
      </li>
    );
  },
  getInitialState: function() {
    return {
      includeWaypoint: true,
      open: false
    };
  },

  arrangeSongInfo(){
    if(this.props.sortBy == 'song')
      return (<span className="text">
                <b>
                  {this.longNameFix(this.props.song.name)}
                </b>
                &nbsp;-&nbsp;
                {this.longNameFix(this.props.song.artist_name)}
              </span>);
    else
      return (<span className="text">
                <b>{this.longNameFix(this.props.song.artist_name)}</b>
                &nbsp;-&nbsp;
               {this.longNameFix(this.props.song.name)}</span>);
  },
  toggleDisplay: function(){
    this.state.open ? this.setState({open: false}) : this.setState({open: true})
  },
  handleWaypointEnter(){
    this.props.songList.showMore();
    this.setState({includeWaypoint: false})
  },
  longNameFix(name){
    return name.length > 34 ? name.substring(0, 34).concat('...') : name
  },
  addWaypoint(){
    //adds a way point 3/4 down the song list
    var SongTest = Math.floor(this.props.songs.length/4*3) == this.props.songIndex;
    if(this.state.includeWaypoint && SongTest)
      return <Waypoint className='waypoint' onEnter={this.handleWaypointEnter} threshold={0.2} />
  },
  addAudio: function(){
    if( this.state.open) 
      return <SongAudio song={this.props.song} />
  },
  shortlistAdd: function(){
    PubSub.publish( 'addSong', this.props.song);
  },

  shortlistTop: function(){
    PubSub.publish( 'topSong', this.props.song);
  }
});

