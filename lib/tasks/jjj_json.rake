require 'csv'
require 'json'

desc 'jjj json parser'
task :parse_json => :environment do
  year = ENV['current_year']
  file_name =  "#{year}_songs_raw.json"
  json_file = File.expand_path(File.join('db', 'fixtures', file_name))

  song_count = 0
  updates = 0
  puts "importing #{json_file}"
  json_contents = File.read(json_file)
  jjj_json = JSON.parse(json_contents, :quirks_mode => true)
  jjj_json.each do |song|
    artist_name = song['artist']
    song_name = song['name']
    jjj_id = song['id']
    jjj_preview = song['track_preview']
    puts "#{artist_name}-#{song_name}"

    artist = Artist.find_by_name(artist_name)
    artist ||= Artist.create(name: artist_name)
    song = artist.songs.where(name:song_name, year: year).first
    unless song
      artist.songs.create(name:song_name, year: year, jjj_id: jjj_id, jjj_preview: jjj_preview)
      song_count += 1
    end
  end
  Song.where(name:nil).delete_all
  Artist.where(name:nil).delete_all
  puts "done! - songs imported #{song_count}, updates #{updates}"
end
