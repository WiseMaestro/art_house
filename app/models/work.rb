class Work < ActiveRecord::Base
  belongs_to :artist
  
  # Stuff to do with attached files is below.
  # Image should have attached file and thumbnail that is smaller.

  has_attached_file :photo, :styles =>  {:index => "200x200", :thumb => "100x100"}
  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type=>['image/jpeg', 'image/png', 'image/gif']  
  validates_attachment_size :photo, :less_than=>1.megabyte
  
  validates :sizex, :presence => true, :numericality => { :greater_than => 100, :less_than_or_equal_to => 500}
  validates :sizey, :presence => true, :numericality => { :greater_than => 100, :less_than_or_equal_to => 800}
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 200}
  validates :artist_id, :numericality => true
  validates_presence_of :artist
  validates :status, :presence => true, :length => {:minimum => 3, :maximum => 200}
  validates :medium, :presence => true, :length => {:minimum => 3, :maximum => 200}
  validates :size, :presence => true, :length => {:minimum => 3, :maximum => 200}
  validates :date, :presence => true, :length => {:minimum => 10, :maximum => 200}  
end
