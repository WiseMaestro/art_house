class Artist < ActiveRecord::Base
  
  has_many :works
  has_attached_file :photo
  validates_presence_of :name, :bio, :sizex, :sizey, :stillthere
  validates_numericality_of :stillthere
end
