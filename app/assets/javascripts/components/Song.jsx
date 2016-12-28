import React from 'react';
import classNames from 'classnames'
import InlineSvg from './InlineSvg';

export default React.createClass({
  render() {
    var classes = classNames({
      'song': true,
      'open': this.state.open,
      'shortlisted': this.state.shortlisted
    });
    return (
      <li className={classes} data-id={this.props.song.id}>
        <div className='song-display' onClick={this.toggleDisplay}>
          {this.arrangeSongInfo()}
          {this.renderWaypoint()}
          {this.renderAudio()}
          <InlineSvg iconClass={'hover-play'} iconName={'#play'} />
          <InlineSvg iconClass={'icon-selected'} iconName={'#tick'} />
        </div>
        <button className='circle-button' onClick={this.shortlistTop} > <InlineSvg iconClass={'icon-top'} iconName={'#arrow-circ'} /> </button>
        <button className='circle-button' onClick={this.shortlistAdd} > <InlineSvg iconClass={'icon-plus'} iconName={'#plus-circ'} /> </button>
      </li>
    );
  },
  renderWaypoint(){
    //adds a way point 3/4 down the song list
    var threeQuarterPoint = Math.floor(this.props.songListLength/4*3),
        SongTest          = threeQuarterPoint == this.props.songIndex;

    if(this.state.includeWaypoint && SongTest)
      return <Waypoint className='waypoint' onEnter={this.handleWaypointEnter} threshold={0.2} />
  },
  renderAudio: function(){
    if( this.state.open )
      return <SongAudio song={this.props.song} />
  },
  arrangeSongInfo: function(){
    if(this.props.sortBy == 'song')
      return (<span className="text">
                <b>
                  {this.props.song.name}
                </b>
                &nbsp;-&nbsp;
                {this.props.song.artistName}
              </span>);
    else
      return (<span className="text">
                <b>{this.props.song.artistName}</b>
                &nbsp;-&nbsp;
               {this.props.song.name}</span>);
  },
  getInitialState: function() {
    return {
      includeWaypoint: true,
      shortlisted: this.props.shortlisted
    };
  },
  componentWillReceiveProps: function(nextProps) {
    this.setState({open: nextProps.open});
  },
  toggleDisplay: function(){
    this.state.open ? this.setState({open: false}) : this.setState({open: true})
  },
  handleWaypointEnter(){
    this.props.songList.showMore();
    this.setState({includeWaypoint: false})
  },
  shortlistAdd: function(){
    this.setState({shortlisted: true})
    PubSub.publish( 'addSong', this.props.song);
  },
  shortlistTop: function(){
    this.setState({shortlisted: true})
    PubSub.publish( 'topSong', this.props.song);
  }
});

