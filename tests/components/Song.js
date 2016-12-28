import React from 'react';
import { shallow } from 'enzyme';
import { expect } from 'chai';
import sinon from 'sinon';
import Song      from '../../app/assets/javascripts/components/Song';

function mockItem(overides = {}) {
  let songData = {
      id: '1',
      name: 'Doing it to death',
      artistName: 'The Kills',
      songListLength: 1,
      open: false,
      shortlisted: false,
      sortBy: 'song'
  };
  for(key in overides.keys){
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
  it('renders tick when added to shortlist');
  it('opens when clicked');
  it('publishes when a song is added');
  it('publishes when a song is added to top');

  //after(function() {
    //global.window.close();
  //});
});
