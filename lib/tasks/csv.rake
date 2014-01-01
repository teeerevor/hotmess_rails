require 'csv'

desc 'csv loader'
task :load_csv => :environment do
  year = ENV['current_year']
  file_name =  "#{year}_songs.csv"
  csv_file = File.expand_path(File.join('db', 'fixtures', file_name))

  puts "importing #{csv_file}"
  song_count = 0
  updates = 0
  CSV.foreach(csv_file, {headers: true, col_sep: "|"}) do |row|
    artist_name = row['artist']
    song_name = row['song']
    youtube_key = row['youtube_key']
    spotify_key = row['spotify_key']
    puts "#{artist_name}-#{song_name}"

    artist = Artist.find_by_name(artist_name)
    artist ||= Artist.create(name: artist_name)
    song = artist.songs.where(name:song_name, year: year).first
    unless song
      artist.songs.create(name:song_name, year: year, youtube_url: youtube_key, spotify_key: spotify_key)
      song_count += 1
    else
      unless song.youtube_url == youtube_key
        song.youtube_url = youtube_key
        song.save
        updates += 1
      end
    end
  end
  Song.where(name:nil).delete_all
  Artist.where(name:nil).delete_all
  puts "done! - songs imported #{song_count}, updates #{updates}"
end

task :save_csv => :environment do
  year = ENV['current_year']
  file_name =  "#{year}_songs.csv"
  csv_file = File.expand_path(File.join('db', 'fixtures', file_name))

  find_params = {conditions: {year: year}, include: 'artist', order: 'artists.name'}
  songs = Song.all(find_params)

  song_count = 0
  CSV.open(csv_file, "wb", {col_sep: "|"}) do |csv|
    csv << ['artist', 'song', 'youtube_key', 'spotify_key']
    songs.each do |s|
      csv << [s.artist.name, s.name, s.youtube_url, s.spotify_key]
      song_count += 1
    end
  end
  puts "done - #{song_count} song exported"
end
