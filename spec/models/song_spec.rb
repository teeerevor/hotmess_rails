require 'spec_helper'

describe Song do
  it 'returns songs for given year' do
    pending
  end

  let(:name){'Start me up'}
  let(:artist){Artist.new(name:'The Stones')}
  it 'returns name and artist as a youtube search string' do
    subject.name = name
    subject.artist = artist
    subject.youtube_search_string.should == 'blerg'
  end
end
