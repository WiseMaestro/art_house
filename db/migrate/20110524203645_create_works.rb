class CreateWorks < ActiveRecord::Migration
  def self.up
    create_table :works do |t|
      t.string :name
      t.integer :artist_id
      t.string :medium
      t.string :date
      t.integer :price
      t.string :status
      t.string :seller
      t.string :size

      t.timestamps
    end
  end

  def self.down
    drop_table :works
  end
end
