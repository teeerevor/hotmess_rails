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
    var endRegex = /|^x|^y|^z/i;
    if(!endRegex.test(startLetter)){
      sequence = this.getLetterSequence(startLetter, 'z');
      return RegExp(sequence + endPostfix.source, 'i');
    }
    return endRegex;
  },

  getSongFilter(startLetter, endLetter){
    if(startLetter == 'top')
      return this.handleTop(endLetter);

    switch(endLetter){
      case 'x':
      case 'y':
      case 'z':
        return this.handleEnd(startLetter);
    }

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
  getInitialState: function() {
    return {
      startFilter: this.props.index,
      endFilter: this.props.index
    };
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

  render() {
    var songs = Sorter.filterSongs(this.props.songs, this.props.sortBy, this.state.startFilter, this.state.endFilter);
    return (
      <div className='song-section'>
        <h3>2015 Song List</h3>
        <ul className='big-list list'>
          {songs.map((song, i) => {
            return <Song key={song._id} {...this.props} songList={this} songIndex={i} song={song} songs={songs}  />;
          })}
        </ul>
      </div>
    );
  }
});


