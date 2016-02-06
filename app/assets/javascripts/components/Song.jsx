Song = React.createClass({
  render() {
    const songClassName = false ? "opened" : "";

    return (
      <li className={'song '+songClassName}>
        <div className='song-display' onClick={this.toggleDisplay}>
          {this.arrangeSongInfo()}
          {this.renderWaypoint()}
          {this.renderAudio()}
        </div>
        <button className='circle-button' onClick={this.shortlistTop} > <InlineSvg iconClass={'icon-top'} iconName={'#arrow-circ'} /> </button>
        <button className='circle-button' onClick={this.shortlistAdd} > <InlineSvg iconClass={'icon-plus'} iconName={'#plus-circ'} /> </button>
      </li>
    );
  },
  renderWaypoint(){
    //adds a way point 3/4 down the song list
    var SongTest = Math.floor(this.props.songs.length/4*3) == this.props.songIndex;
    if(this.state.includeWaypoint && SongTest)
      return <Waypoint className='waypoint' onEnter={this.handleWaypointEnter} threshold={0.2} />
  },
  renderAudio: function(){
    if( this.state.open)
      return <SongAudio song={this.props.song} />
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
                {this.longNameFix(this.props.song.artistName)}
              </span>);
    else
      return (<span className="text">
                <b>{this.longNameFix(this.props.song.artistName)}</b>
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
  shortlistAdd: function(){
    PubSub.publish( 'addSong', this.props.song);
  },

  shortlistTop: function(){
    PubSub.publish( 'topSong', this.props.song);
  }
});

