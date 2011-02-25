class User < ActiveRecord::Base
  validates :email, :presence => true
  validates :email, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  
  has_many :peer_reviews, :through => :peer_review_assignments
  has_many :peer_review_assignments
  has_many :peer_review_solutions, :through => :peer_review_assignments
end
