class ShortList < ActiveRecord::Base
  has_many :short_listed_songs
  has_many :songs, :through => :short_listed_songs
  has_many :artists, :through => :songs

  def short_list_songs(songs)
    short_listed_songs.destroy_all
    add_songs_to_list(songs)
  end

  def add_songs_to_list(songs)
    Song.find(songs)
    songs.each_with_index do |song_id, pos|
      short_listed_songs.create(song_id: song_id, position: pos)
    end
  end

  def format_list_as_text
    text = ''
    short_listed_songs.all(include: {:song => :artist}, order: 'position').each do |sls|
      text += "#{sls.position+1}: #{sls.song.name} - #{sls.song.artist.name}\n"
    end
    text
  end
end
