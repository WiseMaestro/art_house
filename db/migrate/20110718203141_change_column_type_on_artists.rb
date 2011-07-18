class ChangeColumnTypeOnArtists < ActiveRecord::Migration
  def self.up
    change_column( :artists,  :bio, :text)

  end


  def self.down
    change_column( :artists, :bio, :string)
  end
end
