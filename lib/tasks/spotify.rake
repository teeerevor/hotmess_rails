require 'uri'
require 'json'
require 'open-uri'

desc 'spotify loader'
task :get_spotify_ids => :environment do
  year = ENV['current_year']

  Song.where(year: year).each do |song|
    puts "-----------------------------------"
    puts "#{song.name} - #{song.artist.name}"
    url = "http://ws.spotify.com/search/1/track.json?q=#{song.spotify_search_string}"
    puts "search = #{url}"
    begin
      json = JSON.parse(open(url).read)

      if track = json['tracks'].first

      #initial run - matches all words in song titles
      #if song.name.gsub(/\{.*\}/,'').downcase.split(/\W+/).all? {|word| yt_vid_name.include?(word)}
        href = track['href']
        song_key = href.split(':').last

        song.spotify_key = song_key
        song.save
        puts song_key
      else
        puts "no match"
      end
    rescue
      puts "********** error ************"  
      puts "error song = #{song.id}"
      puts url
    end
  end
end

