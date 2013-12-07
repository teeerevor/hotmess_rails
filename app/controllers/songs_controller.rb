class SongsController < ApplicationController
  def index
    @year = ENV['current_year']
    @songs = Song.find_for_year(@year)

    respond_to do |format|
      format.html
      format.json { render @songs.to_json(:include => :artist, :methods => [:short_desc, :content_link])}
    end
  end
end

