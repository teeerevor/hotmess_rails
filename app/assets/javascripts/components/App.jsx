window.App = React.createClass({
  render() {
    return (
      <div>
        <nav className='toggle-sort'>
          <a onClick={this.toggleSortOrder} toggelto={this.state.sortByNext}>{this.state.sortBtnText}</a>
        </nav>

        <div className='lists'>
          <nav className='item-index alpha-index'> {this.renderIndex()} </nav>
          <Shortlist />
          <SongList songs={this.state.songs} index={this.state.index} sortBy={this.state.sortBy} />
        </div>
      </div>
    );
  },
  renderIndex() {
    return ['TOP'].concat("ABCDEFGHIJKLMNOPQRSTUVW".split('')).concat('XYZ').map((index) => {
      return <a key={index} onClick={this.changeFilter}>{index}</a>;
    });
  },
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
  }
});

