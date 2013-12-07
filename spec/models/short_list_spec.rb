require 'spec_helper'

describe ShortList do
  describe '#match' do
    before(:each) do
      @new_song_list
      short_listed_song_arr = [ShortListedSong.new(id: 1, song_id: 2, short_list_id: 1 ), ShortListedSong.new(id: 3, song_id: 4, short_list_id: 1 )]
      subject.should_receive(:short_listed_songs).and_return(short_listed_song_arr)
    end

    it 'will return true when lists match' do
      new_song_list = [2, 4]
      subject.match(new_song_list).should be_true
    end

    it 'will return false when lists dont match' do
      new_song_list = [2, 4, 8, 9]
      subject.match(new_song_list).should be_false
    end
  end
end
