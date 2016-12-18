var LocalStorageMixin = require('react-localstorage');

Shortlist = React.createClass({
  displayName: 'Shortlist',
  mixins: [LocalStorageMixin],
  render(){
    var shortlist = this.state.shortlist;
    var shortlistSongs = this.state.shortlistSongs;
    var blanks= this.blankState();
    return(
      <div className='shortlist-section'>
        <h3>Your Shortlist</h3>
        <div className='shortlist-scroller'>
          <ul className='shortlist list'>
            {shortlist.map((songID, i) => {
              return <ShortlistSong key={ i+1 } song={ shortlistSongs[songID] }/>;
            })}
            {blanks.map((placeholder, index) => {
              if( index >= this.state.shortlist.length )
                return <li key={ index + 1 } className='placeholder'>Pick { placeholder }</li>;
            })}
          </ul>
        </div>
      </div>
    );
  },
  getInitialState: () => {
    return {
      shortlist:     [],
      shortlistSongs: {},
      finalListSize: 10
    };
  },
  blankState: function(){
    return ['One', 'Two','Three','Four','Five','Six','Seven','Eight','Nine','Ten'];
  },
  componentWillMount: function() {
    this.pubsubAdd = PubSub.subscribe('addSong', function(topic, song) {
      this.addSong(song);
    }.bind(this));
    this.pubsubTop = PubSub.subscribe('topSong', function(topic, song) {
      this.addTopSong(song);
    }.bind(this));
    this.pubsubRemove = PubSub.subscribe('removeSong', function(topic, song) {
      this.removeSong(song);
    }.bind(this));
    this.pubsubMoveTop = PubSub.subscribe('moveTopSong', function(topic, song) {
      this.moveTopSong(song);
    }.bind(this));
  },
  componentWillUnmount: function() {
    PubSub.unsubscribe(this.pubsubAdd);
    PubSub.unsubscribe(this.pubsubTop);
    PubSub.unsubscribe(this.pubsubRemove);
    PubSub.unsubscribe(this.pubsubMoveTop);
  },
  addSong: function(song){
    var sl = this.cloneArray(this.state.shortlist);
    var slSongs = this.cloneObject(this.state.shortlistSongs);
    if(sl.indexOf(song.id) < 0){
      sl.push(song.id);
      slSongs[song.id] = song;
      this.setState({ shortlist: sl, shortlistSongs: slSongs });
    }
  },
  addTopSong: function(song){
    var sl = this.cloneArray(this.state.shortlist);
    var slSongs = this.cloneObject(this.state.shortlistSongs);
    if(sl.indexOf(song.id) < 0){
      sl.unshift(song.id);
      slSongs[song.id] = song;
      this.setState({ shortlist: sl, shortlistSongs: slSongs });
    }
  },
  moveTopSong: function(song){
    var sl = this.cloneArray(this.state.shortlist);
    var slSongs = this.cloneObject(this.state.shortlistSongs);
    var index = sl.indexOf(song.id);
    if (index > -1){
      sl.splice(index, 1);
      sl.unshift(song.id);
      this.setState({ shortlist: sl, shortlistSongs: slSongs });
    }
  },
  removeSong: function(song){
    var sl = this.cloneArray(this.state.shortlist);
    var slSongs = this.cloneObject(this.state.shortlistSongs);
    var index = sl.indexOf(song.id);
    if (index > -1){
      sl.splice(index, 1);
      delete slSongs[song.id]
      this.setState({ shortlist: sl, shortlistSongs: slSongs });
    }
  },
  cloneArray: function(array){
    return array.slice(0);
  },
  cloneObject: function(obj){
    return _.extend(obj);
  },
});
