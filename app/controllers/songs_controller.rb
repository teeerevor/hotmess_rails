class SongsController < ApplicationController
  def index
    @year = ENV['current_year']
    @songs = Song.find_for_year(@year).limit(10)
    gon.rabl "app/views/songs/index.json.rabl", as: 'songs'
  end
end

