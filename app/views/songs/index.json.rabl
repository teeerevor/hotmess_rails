collection @songs
node :artistName do |s|
  s.artist.name
end
attributes :id, :name, :youtube_url, :soundcloud_url, :spotify_key, :album_img_url, :year, :artist_id, :desc,
child(:artist) { attributes :id, :name, :image, :desc }
