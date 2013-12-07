collection @songs => 'songs'
attributes :id, :name, :youtube_url, :year, :artist_id
child(:artist) { attributes :name }
