import React from 'react';

export default React.createClass({
  render(){
    let audioBlock;
    switch( this.hasAudio() ){
      case 'youtube':
        audioBlock = this.renderYoutube();
        break;
      case 'soundclound':
        audioBlock = this.renderSoundcloud();
        break;
      default:
        audioBlock = this.renderJJJMp3();
    }

    return (
      <div className='song-audio'>
        { audioBlock }
      </div>
    );
  },
  renderYoutube: function(){
    return( <YoutubeTrack song={this.props.song} /> );
  },
  renderSoundclound: function(){
    return( <div /> );
  },
  renderJJJMp3: function(){
    return( <AudioTrack song={this.props.song} /> );
  },
  hasAudio: function(){
    if(this.props.song.youtube_url) return "youtube";
    if(this.props.song.soundclound_url) return "soundclound";
    return "JJJ"
  }
})
