class AddStillThereToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :stillthere, :integer
  end

  def self.down
    remove_column :artists, :stillthere
  end
end
