class AddJjjFieldsToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :jjj_id, :string
    add_column :songs, :jjj_preview, :string
  end
end
