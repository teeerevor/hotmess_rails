class CreateShortListedSongs < ActiveRecord::Migration
  def change
    create_table :short_listed_songs do |t|
      t.integer :short_list_id
      t.integer :song_id
      t.integer :position
      t.timestamps
    end
  end
end
