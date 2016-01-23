ShortlistSong = React.createClass({
  getInitialState: function() {
    return {};
  },

  longNameFix(name){
    return name.length > 34 ? name.substring(0, 34).concat('...') : name
  },

  shortlistRemove: function(){
    PubSub.publish( 'removeSong', this.props.song);
  },

  shortlistMoveTop: function(){
    PubSub.publish( 'moveTopSong', this.props.song);
  },

  render() {
    return (
      <li className={'song'}>
        <div className='song-wrap'>
        <div className='song-display'>
        <span className="text">
          <b>
            {this.longNameFix(this.props.song.name)}
          </b>
          &nbsp;-&nbsp;
          {this.longNameFix(this.props.song.artist_name)}
        </span>
        </div>
        </div>
        <button onClick={this.shortlistMoveTop} > <InlineSvg iconClass={'icon-top'} iconName={'#up-arrow'} /> </button>
        <button onClick={this.shortlistRemove} > <InlineSvg iconClass={'icon-cross'} iconName={'#cross'} /> </button>
      </li>
    );
  }
});


