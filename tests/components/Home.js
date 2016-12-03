import React from 'react';
import { mount } from 'enzyme';
import { expect } from 'chai';
import sinon from 'sinon';
import Song from '../../app/assets/javascripts/components/Song';

describe('<Song/>', function() {
    wrapper = mount(<Song text="Hello, world!"/>);

    it('`props` contains a `text` property with a value of "Hello, world!"', function() {
        expect(wrapper.props().text).to.equal('Hello, world!');
    });

    it('has an `h1` tag with the text "Home page"', function() {
        expect(wrapper.contains(<h1>Home page</h1>)).to.equal(true);
    });

    after(function() {
        global.window.close();
    });
});
