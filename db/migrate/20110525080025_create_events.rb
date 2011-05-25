class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :date
      t.string :time
      t.string :place

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
