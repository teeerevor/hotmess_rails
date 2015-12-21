require 'json'

desc 'json loader'
task :json_list_load => :environment do
  year = ENV['current_year']
  file_name =  "#{year}_songs.json"
  json_file = File.expand_path(File.join('db', 'fixtures', file_name))

  song_count = 0
  updates = 0
  json_contents = File.read(json_file)
  puts "importing #{json_file}"
  json_file = JSON.parse(json_contents, :quirks_mode => true)

  jjj_json.each do |song|
    song_name = song['song']
    youtube_key = song['youtube_key']
    spotify_key = song['spotify_key']
    jjj_id = song['jjj_id']
    jjj_preview = song['jjj_preview']
    artist_name = song['artist']['name']
    puts "#{artist_name}-#{song_name}"

    artist = Artist.find_by_name(artist_name)
    artist ||= Artist.create(name: artist_name)
    song = artist.songs.where(name:song_name, year: year).first
    unless song
      artist.songs.create(name:song_name, year: year, youtube_url: youtube_key, spotify_key: spotify_key, jjj_id: jjj_id, jjj_preview: jjj_preview)
      song_count += 1
    else
      if song.youtube_url != youtube_key || song.spotify_key != spotify_key || jjj_preview != jjj_preview
        song.youtube_url = youtube_key
        song.spotify_key = spotify_key
        song.jjj_id = jjj_id
        song.jjj_preview = jjj_preview
        song.save
        updates += 1
      end
    end
  end
  Song.where(name:nil).delete_all
  Artist.where(name:nil).delete_all
  puts "done! - songs imported #{song_count}, updates #{updates}"
end

task :json_list_save => :environment do
  year = ENV['current_year']
  file_name =  "#{year}_songs.json"
  json_file = File.expand_path(File.join('db', 'fixtures', file_name))

  find_params = {conditions: {year: year}, include: 'artist', order: 'artists.name'}
  songs = Song.includes(:artist).where(year: year).order('artists.name')

  song_count = songs.size
  File.open(json_file,"w") do |f|
    f.write(songs.to_json(:only => [:name, :year, :youtube_url, :spotify_key, :jjj_id, :jjj_preview], :include => {:artist => {:only => :name}}))
  end
  puts "done - #{song_count} song exported"
end
