ShortlistSong = React.createClass({
  render() {
    return (
      <li className={'song'}>
        <div className='song-wrap'>
        <div className='song-display' onClick={this.jumpToSong}>
        <span className="text">
          <b>
            {this.props.song.name}
          </b>
          {this.props.song.artistName}
        </span>
        </div>
        </div>
        <button onClick={this.shortlistMoveTop} > <InlineSvg iconClass={'icon-top'} iconName={'#arrow-circ'} /> </button>
        <button onClick={this.shortlistRemove} > <InlineSvg iconClass={'icon-cross'} iconName={'#cross-circ'} /> </button>
      </li>
    );
  },
  getInitialState: function() {
    return {};
  },
  shortlistRemove: function(){
    PubSub.publish( 'removeSong', this.props.song);
  },
  shortlistMoveTop: function(){
    PubSub.publish( 'moveTopSong', this.props.song);
  },
  jumpToSong: function(){
    PubSub.publish( 'jumpToSong', this.props.song);
  }
});


