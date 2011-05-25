class Work < ActiveRecord::Base
  belongs_to :artist
  
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 200}
  validates :artist_id, :numericality => true
  validates_presence_of :artist
  validates :status, :presence => true, :length => {:minimum => 3, :maximum => 200}
  validates :medium, :presence => true, :length => {:minimum => 3, :maximum => 200}
  validates :size, :presence => true, :length => {:minimum => 3, :maximum => 200}
  validates :date, :presence => true, :length => {:minimum => 10, :maximum => 200}
  
end
