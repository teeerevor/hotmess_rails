class ShortListedSong < ActiveRecord::Base
  belongs_to :short_list
  belongs_to :song
end
