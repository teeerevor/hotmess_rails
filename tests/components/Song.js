import React from 'react';
import { shallow, mount } from 'enzyme';
import { expect } from 'chai';
import sinon from 'sinon';
import PubSub from 'pubsub-js';
import Song from '../../app/assets/javascripts/components/Song';
import SongAudio from '../../app/assets/javascripts/components/SongAudio';

function mockItem(overides = {}) {
  let songData = {
      id: '1',
      name: 'Doing it to death',
      artistName: 'The Kills',
      songListLength: 1,
      open: false,
      sortBy: 'song'
  };
  for(var key in overides){
    if (!songData.hasOwnProperty(key)) continue;
    songData[key] = overides[key];
  }

  return songData;
}

describe('<Song />', () => {

  it('renders song and artist title', () => {
    const item = mockItem(),
          wrapper = shallow(<Song song={item} />);
    expect(wrapper.text()).to.contain(item.name);
    expect(wrapper.text()).to.contain(item.artistName);
  });

  it('renders tick when added to shortlist', () => {
    const item = mockItem(),
          wrapper = mount(<Song song={item} shortlisted={true} />);
    expect(wrapper.find('.shortlisted')).to.have.length(1);
    expect(wrapper.find('.icon-selected')).to.have.length(1);
  });

  it('shows SongAudio when item is clicked', () => {
    const item = mockItem(),
          wrapper = shallow(<Song song={item} />);
    wrapper.find('.song-dislay').simulate('click');
    expect(wrapper.contains(<SongAudio />)).to.be.true;
  });
  it('publishes when a song is added');
  it('publishes when a song is added to top');

  after(function() {
    global.window.close();
  });
});
