
task :json_save_for_mongodb => :environment do
  year = ENV['current_year']
  file_name =  "#{year}_songs_export.json"
  json_file = File.expand_path(File.join('db', 'fixtures', file_name))

  songs = Song.where(year: year).order('name')

  song_count = songs.size
  File.open(json_file,"w") do |f|
    f.write(songs.to_json(:only => [:id, :name, :artist_id, :year, :youtube_url, :spotify_key, :jjj_id, :jjj_preview]))
  end

  artists = Artist.all.order('name')
  artist_count = artists.size

  file_name =  "#{year}_artists_export.json"
  artist_json_file = File.expand_path(File.join('db', 'fixtures', file_name))
  File.open(artist_json_file,"w") do |f|
    f.write(artists.to_json(:only => [:id, :name]))
  end
  puts "done - #{artist_count} artists exported"
  puts "#{song_count} song exported"
end

task :json_save_for_mongodb_denorm => :environment do
  year = ENV['current_year']
  file_name =  "#{year}_songs_export.json"
  json_file = File.expand_path(File.join('db', 'fixtures', file_name))

  songs = Song.where(year: year).order('name')

  song_count = songs.size
  File.open(json_file,"w") do |f|
    f.write(songs.to_json(:only => [:id, :name, :artist_id, :year, :youtube_url, :spotify_key, :jjj_id, :jjj_preview], :methods => :artist_name))
  end

  puts "#{song_count} song exported"
end
