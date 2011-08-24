class AddPhotoColumnsToWork < ActiveRecord::Migration
  def self.up
    add_column :works, :photo_file_name,    :string
    add_column :works, :photo_content_type, :string
    add_column :works, :photo_file_size,    :integer
    add_column :works, :photo_updated_at,   :datetime
    add_column :works, :thumbnail_file_name,    :string
    add_column :works, :thumbnail_content_type, :string
    add_column :works, :thumbnail_file_size,    :integer
    add_column :works, :thumbnail_updated_at,   :datetime
  end

  def self.down
    remove_column :works, :photo_file_name
    remove_column :works, :photo_content_type
    remove_column :works, :photo_file_size
    remove_column :works, :photo_updated_at
    remove_column :works, :thumbnail_file_name
    remove_column :works, :thumbnail_content_type
    remove_column :works, :thumbnail_file_size
    remove_column :works, :thumbnail_updated_at
  end
end
