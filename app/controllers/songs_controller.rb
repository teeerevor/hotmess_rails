class SongsController < ApplicationController
  def index
    @year = ENV['current_year']
    @songs = Song.find_for_year(@year)

    respond_to do |format|
      format.html
      format.json
    end
  end
end

