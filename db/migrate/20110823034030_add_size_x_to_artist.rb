class AddSizeXToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :sizex, :string, :default => "350"
  end

  def self.down
    remove_column :artists, :sizex
  end
end
