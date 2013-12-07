require 'uri'
require 'nokogiri'
require 'open-uri'

class Lastfm < Thor
  desc "grab_artist_dets", "import given csv file"
  def grab_artist_dets
    require File.expand_path('config/boot.rb')

    lastfm_api_key = ENV['lastfm_api_key']
    #Song.all(:include => :artist, :order => 'songs.name').each do |song|
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
end
