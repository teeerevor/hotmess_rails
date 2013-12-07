class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.integer :artist_id
      t.text :desc
      t.integer :year
      t.string :youtube_url
      t.string :soundcloud_url
      t.string :album_img_url
      t.timestamps
    end
  end
end
