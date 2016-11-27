window.App = React.createClass({
  render() {
    return (
      <div>
        <div className='lists'>
          <nav className='item-index alpha-index'> {this.renderIndex()} </nav>
          <Shortlist />
          <SongList index={this.state.index} sortBy={this.state.sortBy} {...this.props} />
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
      index:'top'
    };
  },
  changeFilter(e) {
    this.setState({index: e.target.text.toLowerCase()});
  }
});

