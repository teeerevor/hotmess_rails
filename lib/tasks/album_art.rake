require 'nokogiri'
require 'open-uri'
require 'googleajax'

desc 'album art loader'
task :get_art => :environment do
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

task :albumart_org => :environment do
  year = ENV['current_year']

  Song.where(year: year, album_img_url: nil).each do |song|
    puts "-----------------------------------"
    puts "#{song.name} - #{song.artist.name}"
    url = "http://www.albumart.org/index.php?searchk=#{URI::encode(song.artist.name)}&itempage=1&newsearch=1&searchindex=Music"
    puts "search = #{url}"
    begin
      doc = Nokogiri::HTML(open(url))
      image_link = doc.xpath('//a[@class="thickbox"]/@href').first.value
      puts "image link = [#{image_link}]"

      song.album_img_url = image_link
      song.save
    rescue
      puts "********** error ************"
      puts "error song = #{song.id}"
    end
  end
end
