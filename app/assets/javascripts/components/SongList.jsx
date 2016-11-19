sorter = window.listSorter;

SongList = React.createClass({
  render() {
    return (
      <div className='song-section'>
        <h3>2015 Song List</h3>
        <div className='scroller'>
          <ul className='big-list list'>
            {this.state.songs.map((song, i) => {
              song.index = i;
              var openSong = this.state.currentSong.index === i;
              return <Song key={song.id} {...this.props} songList={this} songIndex={i} song={song} songs={this.state.songs} open={openSong} />;
            })}
          </ul>
        </div>
      </div>
    );
  },
  getInitialState: function() {
    this.nextSongPos = '';
    return {
      startFilter: this.props.index,
      endFilter: this.props.index,
      currentSong: {id: -1},
      songs: sorter.filterSongs(this.props.songs, this.props.sortBy, this.props.index, this.props.index)
    };
  },
  componentWillMount: function() {
    var songList =  this;
    this.pubsubNext = PubSub.subscribe('playerNext', function(topic, currentSong) {
      songList.getNextSong(currentSong);
    }.bind(this));
    this.pubsubPrev = PubSub.subscribe('playerPrevious', function(topic, currentSong) {
      songList.getPreviousSong(currentSong);
    }.bind(this));
  },
  componentWillUnmount: function() {
    PubSub.unsubscribe(this.pubsubNext);
    PubSub.unsubscribe(this.pubsubPrev);
  },
  componentWillReceiveProps: function(nextProps) {
    this.setState({
      currentSong: {id: -1},
      startFilter: nextProps.index,
      endFilter: nextProps.index,
      songs: sorter.filterSongs(this.props.songs, this.props.sortBy, nextProps.index, nextProps.index)
    });
  },
  showMore(){
    var moreIndex = sorter.getNextLetter(this.state.endFilter);
    this.setState({
      endFilter: moreIndex,
      songs: sorter.filterSongs(this.props.songs, this.props.sortBy, this.state.startFilter, moreIndex)
    });
  },
  getNextSong: function(song){
    var nextSong = this.state.songs[song.index + 1];
    PubSub.publish('updateCurrentSong', nextSong);
    this.setState({currentSong: nextSong});
  },
  getPreviousSong: function(song){
    var nextSong = this.state.songs[song.index - 1];
    PubSub.publish('updateCurrentSong', nextSong);
    this.setState({currentSong: nextSong});
  }
});
