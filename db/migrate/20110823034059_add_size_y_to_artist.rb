class AddSizeYToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :sizey, :string, :default => "375"
  end

  def self.down
    remove_column :artists, :sizey
  end
end
