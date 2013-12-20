require 'uri'
require 'nokogiri'
require 'open-uri'
require 'csv'

desc 'get jjj hottest 100 songs'
task :get_hottest_songs => :environment do
  #2012url
  #jjj_url = 'http://www2b.abc.net.au/votecentral/Client/PlaceVote.aspx?E=96&IX=0&IG='
  jjj_url = 'http://www2b.abc.net.au/votecentral/Client/PlaceVote.aspx?E=106&IX=1&IG=0'
  year = ENV['current_year']

  song_count = 0
  (0..26).each do |i|
    url = jjj_url + i.to_s
    doc = Nokogiri::XML(open(url))
    songs = doc.css('.IndexPageContent').first.css('label')
    songs.each do |song|
      artist = song.css('.artist').text
      song = song.css('.title').text
      puts "#{artist} - #{song}"
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
