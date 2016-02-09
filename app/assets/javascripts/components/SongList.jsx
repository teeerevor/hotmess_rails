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
    var songList = this;
    var songs = Sorter.filterSongs(this.props.songs, this.props.sortBy, this.state.startFilter, this.state.endFilter);
    return (
      <div className='song-section'>
        <h3>2015 Song List</h3>
        <div className='scroller'>
          <ul className='big-list list'>
            {songs.map((song, i) => {
              return <Song key={song.id} {...this.props} songList={this} songIndex={i} song={song} songs={songs} openOnLoad={songList.openSong(i)} />;
            })}
          </ul>
        </div>
      </div>
    );
  },
  getInitialState: function() {
    this.nextSong = {id: 0}
    return {
      startFilter: this.props.index,
      endFilter: this.props.index,
      switchTo: '',
      currentSong: {id: -1}
    };
  },
  componentWillMount: function() {
    var songList =  this;
    this.pubsubNext = PubSub.subscribe('playerNext', function(topic, currentSong) {
      songList.setState({currentSong: currentSong, switchTo: 'next'})
      this.nextSong = currentSong;
    }.bind(this));
    this.pubsubPrev = PubSub.subscribe('playerPrevious', function(topic, currentSong) {
      songList.setState({currentSong: currentSong, switchTo: 'previous'})
      this.nextSong = currentSong;
    }.bind(this));
  },
  componentWillUnmount: function() {
    PubSub.unsubscribe(this.pubsubNext);
    PubSub.unsubscribe(this.pubsubPrev);
  },
  componentWillReceiveProps: function(nextProps) {
    this.setState({
      startFilter: nextProps.index,
      endFilter: nextProps.index
    });
  },
  showMore(){
    var moreIndex = Sorter.getNextLetter(this.state.endFilter);
    this.setState({
      endFilter: moreIndex
    });
  },
  openSong: function(songIndex){
    if( this.state.currentSong.id == this.nextSong.id){
      if( this.isNextSong(songIndex) || this.isPreviousSong(songIndex)){
        console.log('pub updateCurrentSong');
        this.nextSong = this.props.songs[songIndex];
        PubSub.publish('updateCurrentSong', this.nextSong)
        return true;
      }
    }
    return false;
  },
  isNextSong: function(songIndex){
    var next = this.state.switchTo === 'next';
    var notFirstItem = songIndex > 0;
    var nextSongTest = next && notFirstItem && this.props.songs[songIndex - 1].id === this.state.currentSong.id;
    return nextSongTest;
  },
  isPreviousSong: function(songIndex){
    var prev = this.state.switchTo === 'previous';
    var notLastItem = songIndex < this.props.songs.length;
    var prevSongTest = prev && notLastItem && this.props.songs[songIndex + 1].id === this.state.currentSong.id;
    return prevSongTest;
  }
});
