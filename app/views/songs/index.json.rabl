collection @songs
attributes :id, :name, :youtube_url, :soundcloud_url, :spotify_key, :album_img_url, :year, :artist_id, :desc,
child(:artist) { attributes :id, :name, :image, :desc }
