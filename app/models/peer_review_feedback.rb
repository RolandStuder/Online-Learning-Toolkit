class PeerReviewFeedback < ActiveRecord::Base
  belongs_to :peer_review_assignment
  belongs_to :peer_review_solution
  
  validates_presence_of :peer_review_assignment, :peer_review_solution
  validates_uniqueness_of :peer_review_assignment_id, :scope => :peer_review_solution_id
end
