class ShortListsController < ApplicationController
  def show
    @email = params[:email]
    @year = params[:year] || ENV['current_year']

    @short_list = ShortList.find_by_email_and_year(@email, @year)
    @short_list_songs = @short_list.short_listed_songs.all.includes(:song => :artist).order('short_listed_songs.position')
    @songs = @short_list_songs.map(&:song)
    gon.rabl "app/views/songs/index.json.rabl", as: 'songs'

    setup_for_html if request.format == :html

    render 'songs/index'

  rescue
    error_msg = "Short list for that email does not exist"
    respond_to do |format|
      format.html { redirect_to root_path, :flash => { :error => "Short list for that email does not exist" }}
      format.json { render status: 404, json: @controller.to_json }
    end
  end

  def update
    email = params[:email]
    year = params[:year] || ENV['current_year']
    unless params[:songs].blank?
      songs_list = params[:songs]
      unless @short_list = ShortList.find_by_email_and_year(email, year)
        @short_list = ShortList.create(email: email, year: year)
      end
      @short_list.short_list_songs(songs_list)
      render status: 200, json: @controller.to_json
    end
  end

  def setup_for_html
    gon.rabl "app/views/songs/index.json.rabl", as: 'shortlist'
    load_songlist
  end

  def load_songlist
    @songs = Song.find_for_year(@year)
    gon.rabl "app/views/songs/index.json.rabl", as: 'songs'
  end
end

