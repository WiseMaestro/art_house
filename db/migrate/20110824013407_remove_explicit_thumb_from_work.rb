class RemoveExplicitThumbFromWork < ActiveRecord::Migration
  def self.up
    remove_column :works, :thumbnail_file_name
    remove_column :works, :thumbnail_content_type
    remove_column :works, :thumbnail_file_size
    remove_column :works, :thumbnail_updated_at
  end

  def self.down
    add_column :works, :thumbnail_file_name,    :string
    add_column :works, :thumbnail_content_type, :string
    add_column :works, :thumbnail_file_size,    :integer
    add_column :works, :thumbnail_updated_at,   :datetime
  end
end
