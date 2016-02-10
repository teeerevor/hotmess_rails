Sorter = {
  getNextLetter(letter){
    switch(letter){
      case 'top':
        return 'a';
      case 'z':
        return 'z';
      default :
        return String.fromCharCode(letter.charCodeAt(letter.length-1)+1);
    }
  },
  getLetterSequence(start, end){
    //returns eg ^a|^b
    var letterSet = [];
    for(letter = start;; letter = this.getNextLetter(letter)){
      letterSet.push('^'+letter);
      if (letter == end) break;
    }
    return letterSet.join('|');
  },
  handleTop(endLetter){
    var topRegex = /^\W|^\d|^a|/i;
    if(endLetter != 'top'){
      sequence = this.getLetterSequence('a', endLetter);
      return RegExp(topRegex.source + sequence, 'i');
    }
    return topRegex;
  },
  handleEnd(startLetter){
    var endRegex = /^x|^y|^z/i;
    if(!endRegex.test(startLetter)){
      sequence = this.getLetterSequence(startLetter, 'z');
      return RegExp(sequence + endPostfix.source, 'i');
    }
    return endRegex;
  },
  getSongFilter(startLetter, endLetter){
    if(startLetter == 'top')
      return this.handleTop(endLetter);
    if(startLetter == 'xyz')
      return this.handleEnd(startLetter);

    sequence = this.getLetterSequence(startLetter, endLetter);
    return RegExp(sequence, 'i');
  },
  filterSongs(songs, filterBy, startsWith, endsWith){
    var songFilter = this.getSongFilter(startsWith, endsWith);
    return songs.filter((song) => {
      switch(filterBy){
        case 'song':
          return songFilter.test(song.name);
        case 'artist':
          return songFilter.test(song.artist_name);
      }
    });
  }
};

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
      songs: Sorter.filterSongs(this.props.songs, this.props.sortBy, this.props.index, this.props.index)
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
      songs: Sorter.filterSongs(this.props.songs, this.props.sortBy, nextProps.index, nextProps.index)
    });
  },
  showMore(){
    var moreIndex = Sorter.getNextLetter(this.state.endFilter);
    this.setState({
      endFilter: moreIndex,
      songs: Sorter.filterSongs(this.props.songs, this.props.sortBy, this.state.startFilter, moreIndex)
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
