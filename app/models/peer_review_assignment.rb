class PeerReviewAssignment < ActiveRecord::Base
  belongs_to :peer_review
  belongs_to :user
  has_many :peer_review_solutions
  has_many :peer_review_feedbacks
  
  validates_presence_of :peer_review, :user
  validates_uniqueness_of :peer_review_id, :scope => :user_id
  
end
