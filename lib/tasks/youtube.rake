require 'uri'
require 'nokogiri'
require 'open-uri'
require 'googleajax'

desc 'youtube loader'
task :load_youtube => :environment do
  year = ENV['current_year']

  Song.where(year: year, youtube_url: nil).each do |song|
    puts "-----------------------------------"
    puts "#{song.name} - #{song.artist.name}"
    #url = "https://www.youtube.com/results?search_query=#{URI::encode(song.youtube_search_string + " official -review" )}"
    #url = "https://www.youtube.com/results?search_query=#{URI::encode(song.youtube_search_string + " vevo -review" )}"
    url = "https://www.youtube.com/results?search_query=#{URI::encode(song.youtube_search_string)}"
    puts "search = #{url}"
    begin
      doc = Nokogiri::HTML(open(url))
      yt_vid_name = doc.css('.yt-lockup-title a').first.text.strip
      puts "vid_name = [#{yt_vid_name}]"

      yt_vid_name.downcase!
      #initial run - matches all words in song titles
      #if song.name.downcase.split(/\W+/).all? {|word| yt_vid_name.include?(word)}
      #second run removes {ft ...}
      if song.name.gsub(/\{.*\}/,'').downcase.split(/\W+/).all? {|word| yt_vid_name.include?(word)}
        url = doc.css('.yt-lockup-title a').first.attr('href')
        song.youtube_url = url.gsub(/\/watch\?v=/i ,'')
        song.save
        puts song.youtube_url
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

desc 'fix youtube_urls'
task :update_youtube_urls => :environment do
  year = ENV['current_year']

  updates = {
    '2382': '',
    '2419': '',
    '2432': '',
    '2453': '',
    '2478': '',
    '2492': '',
    '2506': '',
    '2522': '',
    '2594': '',
    '2675': '',
    '2684': '',
    '2759': '',
    '2793': '',
    '2807': '',
    '2810': '',
    '2808': '',
    '2806': '',
    '2815': '',
    '2888': '',
    '2905': '',
    '2907': '',
  }
  updates.keys.each do |key|
    song = Song.find(key)
    puts "-----------------------------------"
    puts "#{song.name} - #{song.artist.name}"
    song.youtube_url = updates[key]
    song.save
  end
end

