
require 'nokogiri'
require 'open-uri'
require 'googleajax'

class AlbumArt < Thor
  desc "get_em", "import given csv file"
  def get_em
    require File.expand_path('config/boot.rb')

    GoogleAjax.referer = "hotmess100.io"
    Song.all.each do |song|
      puts "artist/song = #{song.artist.name}|#{song.name}"
      puts "search_string = #{song.youtube_search_string}"
      begin
        GoogleAjax::Search.images(song.youtube_search_string+'+cover')[:results].each do |img|
          if img[:width] == img[:height]
            song.album_img_url = img[:url]
            song.save
            puts img[:url]
            break
          end
        end
      rescue
        puts "********** error ************"  
        puts "song = #{song.id}"
      end
    end
  end
end
