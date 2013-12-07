require 'uri'
require 'nokogiri'
require 'open-uri'
require 'googleajax'

desc 'youtube loader'
task :load_youtube => :environment do
  year = ENV['current_year']

  Song.where(year: year).each do |song|
    puts "artist = #{song.artist.name}|#{song.name}"
    url = "http://www.youtube.com/results?search_query=#{URI::encode(song.youtube_search_string)}"
    puts URI::encode(song.youtube_search_string)
    begin
      doc = Nokogiri::HTML(open(url))
      url = doc.css('#search-results').first.css('a').first.attr('href')
      puts url
      song.youtube_url = url.gsub(/\/watch\?v=/i ,'')
      song.save
      puts song.youtube_url
    rescue
      puts "********** error ************"  
      puts "song = #{song.id}"
      puts url
    end
  end
end
