class CreateShortLists < ActiveRecord::Migration
  def change
    create_table :short_lists do |t|
      t.string :email
      t.integer :year
      t.timestamps
    end
  end
end
