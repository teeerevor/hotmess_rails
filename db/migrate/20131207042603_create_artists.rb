class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.text :desc
      t.string :image
      t.timestamps
    end
  end
end
