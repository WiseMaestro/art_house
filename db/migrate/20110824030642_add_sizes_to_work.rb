class AddSizesToWork < ActiveRecord::Migration
  def self.up
    add_column :works, :sizex, :string
    add_column :works, :sizey, :string
  end

  def self.down
    remove_column :works, :sizex
    remove_column :works, :sizey
  end
end
