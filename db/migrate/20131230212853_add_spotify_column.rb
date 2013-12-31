class AddSpotifyColumn < ActiveRecord::Migration
  def change
    add_column :songs, :spotify_key, :string
  end
end
