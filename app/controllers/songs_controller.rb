class SongsController < ApplicationController
  caches_action :index

  def index
    @year = ENV['current_year']
    @songs = Song.find_for_year(@year)
    gon.rabl "app/views/songs/index.json.rabl", as: 'songs'
  end
end

