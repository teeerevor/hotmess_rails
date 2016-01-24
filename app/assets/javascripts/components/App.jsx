window.App = React.createClass({
  getInitialState: function(){
    return {
      index:       'top',
      sortBy:      'song',
      sortByNext:  'artist',
      sortBtnText: 'Sort by artist',
      songs:        this.props.songs,
      songsByArtist: this.props.songs
    };
  },

  getSongData(){
    return this.state.sortBy == 'song' ? this.data.songs : this.data.songsByArtist;
  },

  changeFilter(e) {
    this.setState({index: e.target.text.toLowerCase()});
  },

  toggleSortOrder(e) {
    this.setState({sortBtnText: 'Sorting...'});
    var sortBy = this.state.sortByNext;
    this.setState({
      index:        'top',
      sortBy:       sortBy,
      sortByNext:   this.state.sortBy,
      sortBtnText:  'Sort by '+this.state.sortBy
    });
  },

  renderIndex() {
    return ['TOP'].concat("ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('')).map((index) => {
      return <a key={index} onClick={this.changeFilter}>{index}</a>;
    });
  },

  render() {
    return (
      <div>
        <nav className='toggle-sort'>
          <a onClick={this.toggleSortOrder} toggelto={this.state.sortByNext}>{this.state.sortBtnText}</a>
        </nav>

        <nav className='item-index'>
          {this.renderIndex()}
        </nav>

        <div className='lists'>
          <Shortlist />
          <SongList songs={this.state.songs} index={this.state.index} sortBy={this.state.sortBy} />
        </div>
      </div>
    );
  }
});

