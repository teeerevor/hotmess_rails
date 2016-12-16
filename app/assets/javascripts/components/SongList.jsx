#= require songListFilter
filter = new SongListFilter();

SongList = React.createClass({
  render() {
    let songBlock;
    if(this.state.songs.length == 0){
      songBlock = this.renderEmptyState();
    }else{
      songBlock = this.renderSongList();
    }
    return (
      <div className='song-section'>
        <nav className='toggle-sort'>
          <a onClick={this.toggleSortOrder}>{this.getSorterButtonLabel()}</a>
        </nav>
        <h3>{window.hotmess100.year} Song List</h3>
        { songBlock }
      </div>
    );
  },
  renderEmptyState: function(){
    return(
      <div className='emptyState'>
        <InlineSvg iconClass={'no-tunes'} iconName={'#no-tunes'} />
        <h4>
          WOAH! NO TUNES.
        </h4>
        <p>
          There are no <b>{this.state.sortBy}s</b> starting with <b>'{this.state.startFilter.toUpperCase()}'</b> in this list.
        </p>

        <button data-startFilter="{this.state.startFilter}" onClick={this.showPrevAlphaIndex}>BACK UP!</button>
        <button data-startFilter="{this.state.startFilter}" onClick={this.showNextAlphaIndex}>GO FORTH!</button>
      </div>
    );
  },
  renderSongList: function(){
    return(
      <div className='scroller'>
        <ul className='big-list list'>
          {this.state.songs.map((song, i) => {
            song.index = i;
            var openSong = this.state.currentSong.id === song.id;
            {if(openSong) console.log(song)}
            return <Song key={song.id}  songList={this} songIndex={i} song={song} songs={this.state.songs} open={openSong} sortBy={this.state.sortBy}/>;
          })}
        </ul>
      </div>
    );
  },
  getInitialState: function() {
    var sortBy = 'song';
    return {
      sortBy:      sortBy,
      startFilter: this.props.index,
      endFilter:   this.props.index,
      currentSong: {id: -1},
      songData: this.props.songs,
      songs: filter.filterSongs(this.props.songs, sortBy, this.props.index, this.props.index)
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
    this.pubsubRandom = PubSub.subscribe('playerRandom', function(topic) {
      songList.playRandomSong();
    }.bind(this));
    this.pubsubJumpToSong = PubSub.subscribe('jumpToSong', function(topic, song) {
      songList.jumpToSong(song);
    }.bind(this));
  },
  componentWillUnmount: function() {
    PubSub.unsubscribe(this.pubsubNext);
    PubSub.unsubscribe(this.pubsubPrev);
  },
  componentWillReceiveProps: function(nextProps) {
    this.setState({
      currentSong: {},
      startFilter: nextProps.index,
      endFilter: nextProps.index,
      songs: filter.filterSongs(this.state.songData, this.state.sortBy, nextProps.index, nextProps.index)
    });
  },
  getSorterButtonLabel: function(){
    var sortBtnText = 'Sorted by ';
    return sortBtnText + this.state.sortBy;
  },
  toggleSortOrder: function(){
    var newSortBy, songdata;
    if( this.state.sortBy == 'song' ){
      newSortBy =  'artist';
      songData  = this.props.artistSongs;
    } else {
      newSortBy = 'song';
      songData  = this.props.songs;
    }

    this.setState({
      currentSong: {},
      index:  'top',
      sortBy: newSortBy,
      songData: songData,
      songs: filter.filterSongs(songData, newSortBy, 'top', 'top')
    });
  },
  showMore: function(){
    var moreIndex = filter.getNextLetter(this.state.endFilter);
    this.setState({
      endFilter: moreIndex,
      songs: filter.filterSongs(this.state.songData, this.state.sortBy, this.state.startFilter, moreIndex)
    });
  },
  showPrevAlphaIndex: function(){
    var moreIndex = filter.getNextLetter(this.state.endFilter);
    this.setState({
      endFilter: moreIndex,
      songs: filter.filterSongs(this.state.songData, this.state.sortBy, this.state.startFilter, moreIndex)
    });
  },
  showNextAlphaIndex: function(){
    var moreIndex = filter.getNextLetter(this.state.endFilter);
    this.setState({
      endFilter: moreIndex,
      songs: filter.filterSongs(this.state.songData, this.state.sortBy, this.state.startFilter, moreIndex)
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
  },
  playRandomSong: function(){
    var songNumber = Math.round(Math.random() * this.state.songData.length),
        song = this.state.songData[songNumber],
        songFirstLetter = song.name.charAt(0),
        filterLetter = filter.checkLetter(songFirstLetter);

    this.setState({
      currentSong: song,
      endFilter: filterLetter,
      sortBy: 'song',
      startFilter: filterLetter,
      songs: filter.filterSongs(this.state.songData, this.state.sortBy, songFirstLetter, songFirstLetter)
    });
  },
  jumpToSong: function(song){
    var songFirstLetter = song.name.charAt(0),
        filterLetter = filter.checkLetter(songFirstLetter);
    console.log(filterLetter);

    this.setState({
      currentSong: song,
      endFilter: filterLetter,
      sortBy: 'song',
      startFilter: filterLetter,
      songs: filter.filterSongs(this.state.songData, this.state.sortBy, songFirstLetter, songFirstLetter)
    });
  }
  
});
