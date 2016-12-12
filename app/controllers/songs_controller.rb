class SongsController < ApplicationController
  caches_action :index

  def index
    @year = ENV['current_year']
    @albums = []
    @songs = Song.includes(:artist).where(year: @year).order(:name).limit 100
    gon.rabl "app/views/songs/index.json.rabl", as: 'initial_songs'
    @songs = Song.includes(:artist).where(year: @year).order(:name)
    gon.rabl "app/views/songs/index.json.rabl", as: 'songs'
    @songs = Song.includes(:artist).where(year: @year).order('artists.name')
    gon.rabl "app/views/songs/index.json.rabl", as: 'songs_by_artists'
  end
end

