require 'uri'
require 'nokogiri'
require 'open-uri'

desc 'lastfm loader'
task :load_lastfm => :environment do
  lastfm_api_key = ENV['lastfm_api_key']

  Artist.all.each do |artist|
    #artist = song.artist
    puts "artist = #{artist.the_name_fix}"
    url = "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=#{URI.escape(artist.the_name_fix)}&api_key=#{lastfm_api_key}"
    begin
      doc = Nokogiri::XML(open(url))
      artist.image = doc.css('image[@size="extralarge"]').first.text
      desc = doc.css('bio summary').text
      if desc =~ /ID3 tags/i
        puts '* fail *'
        puts url
        desc = 'fail'
      end
      #remove the htmls
      artist.desc = desc.gsub(/<(?:"[^"]*"['"]*|'[^']*'['"]*|[^'">])+>/, '')
      artist.save
    rescue
      puts "********** error ************"
      puts url
    end
  end
end
