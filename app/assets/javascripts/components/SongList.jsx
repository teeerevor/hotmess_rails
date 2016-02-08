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
    var songs = Sorter.filterSongs(this.props.songs, this.props.sortBy, this.state.startFilter, this.state.endFilter);
    return (
      <div className='song-section'>
        <h3>2015 Song List</h3>
        <div className='scroller'>
          <ul className='big-list list'>
            {songs.map((song, i) => {
              if(this.open(i))
                debugger

              return <Song key={song.id} {...this.props} songList={this} songIndex={i} song={song} songs={songs} open={this.open(i)} />;
            })}
          </ul>
        </div>
      </div>
    );
  },
  getInitialState: function() {
    return {
      startFilter: this.props.index,
      endFilter: this.props.index,
      switchTo: ''
    };
  },
  componentWillMount: function() {
    var songList =  this
    this.pubsubNext = PubSub.subscribe('playerNext', function(topic, currentSong) {
      this.setState({currentSong: currentSong, switchTo: 'next'})
    }.bind(this));
    this.pubsubPrev = PubSub.subscribe('playerPrevious', function(topic, currentSong) {
      this.setState({currentSong: currentSong, switchTo: 'previous'})
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
  open: function(songIndex){
    var open = false;
    if(this.state.switchTo === 'next' && songIndex > 0 && this.props.songs[songIndex - 1].id === this.state.currentSong.id )
      open = true;
    if(this.state.switchTo === 'previous' && songIndex < this.props.songs.length && this.props.songs[songIndex + 1].id === this.state.currentSong.id )
      open = true;
    return open;
  }
});
