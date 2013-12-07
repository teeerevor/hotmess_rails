require 'csv'

class Csv < Thor
  desc "import [NAME]", "import given csv file"
  method_options :year => 2011
  method_options :file_name => nil
  def import
    require File.expand_path('config/boot.rb')

    year = options[:year]
    file_name = options[:file_name] || "#{year}_songs.csv"
    csv_file = File.expand_path(File.join('db', 'fixtures', file_name))

    unless File.exists? csv_file
      puts "file does not exist"
      puts "looking for #{csv_file}"
      return
    end

    puts "importing #{csv_file}"
    songs = 0
    CSV.foreach(csv_file, {headers: true, col_sep: "|"}) do |row|
      artist_name = row['artist']
      song_name = row['song']
      puts "#{artist_name}-#{song_name}"

      artist = Artist.find_by_name(artist_name)
      artist ||= Artist.create(name: artist_name)
      song = artist.songs.where(name:song_name, year: year).first
      unless song
        artist.songs.create(name:song_name, year: year)
        songs += 1
      end
    end
    puts "done! - songs imported #{songs}"
  end
end
