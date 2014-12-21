require 'uri'
require 'nokogiri'
require 'open-uri'
require 'csv'

desc 'get jjj hottest 100 songs'
task :get_hottest_files => :environment do
  year = ENV['current_year']

  song_count = 0
  ('A'..'Z').to_a.append('znum').each do |letter|
    file_name =  "#{letter}.html"
    file = File.expand_path(File.join('public', '2014', file_name))
    puts "---------------Grabbing the #{letter}s--------------"
    doc = Nokogiri::XML(open(file))
    doc.css('.tracklist .textContainer').each do |block|
      song = block.css('div').first.text
      artist = block.css('.secondary-type').text
      puts "#{song} - #{artist}"
      db_artist = Artist.find_by_name(artist)
      db_artist ||= Artist.create(name: artist)
      db_song = db_artist.songs.where(name:song, year: year).first
      unless db_song
        db_artist.songs.create(name:song, year: year)
        song_count += 1
      end
    end
  end
  puts "done - #{song_count} songs"
end
