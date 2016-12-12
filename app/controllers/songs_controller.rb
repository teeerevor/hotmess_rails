class SongsController < ApplicationController
  caches_action :index

  def index
    @year = ENV['current_year']
    #@albums = Song.where(year: @year).where.not(album_img_url: nil).map(&:album_img_url).uniq.shuffle.sample 30
    @albums = []
    @songs = Song.includes(:artist).where(year: 2016).order(:name).limit 100
    gon.rabl "app/views/songs/index.json.rabl", as: 'initial_songs'
    @songs = Song.includes(:artist).where(year: 2016).order(:name)
    gon.rabl "app/views/songs/index.json.rabl", as: 'songs'
    @songs = Song.includes(:artist).where(year: 2016).order('artists.name')
    gon.rabl "app/views/songs/index.json.rabl", as: 'songs_by_artists'
  end
end

