class ShortListsController < ApplicationController
  def show
    @email = params[:email]
    @year = params[:year] || ENV['current_year']
    @short_list = ShortList.find_by_email_and_year(@email, @year)
    @short_list_songs = @short_list.short_listed_songs.all( :include => {:song => :artist}, :order => 'short_listed_songs.position')
    @songs = @short_list_songs.map{|sls| sls.song}

    respond_to do |format|
      format.html
      format.json
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
    end
  end
end

