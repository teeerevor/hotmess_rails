class Song < ActiveRecord::Base
  belongs_to :artist
  has_many :short_listed_songs
  has_many :short_lists, :through => :short_listed_songs

  def self.find_for_year(year = ENV['current_year'])
    find_params = {conditions: {year: year}, include: 'artist', order: 'songs.name'}
    all(find_params)
  end

  def youtube_search_string
    "#{self.name} #{self.artist.the_name_fix}"
  end
end
