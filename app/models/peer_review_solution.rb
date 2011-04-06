class PeerReviewSolution < ActiveRecord::Base
  belongs_to :peer_review_assignment
  belongs_to :user
  belongs_to :peer_review
  has_many :peer_review_feedbacks
  
  validates_presence_of :peer_review_assignment, :text
  
  include ActionView::Helpers::SanitizeHelper
  before_save :sanitize_entry
  
  def return_feedback
    self.feedback_returned = true
    self.save
    PeerReviewMailer.return_feedback(self).deliver
    
  end
  
  def check_if_feedback_is_complete
    unless self.feedback_returned == true
      if self.peer_review_feedbacks.where(:text => nil).count == 0
         self.return_feedback
      end
    end
  end
  
  private
  
  def sanitize_entry
    self.text = sanitize(self.text, :tags => %w(p strong em ul ol li div a h1 h2 h3 h4 h5 h6))
  end
  
end
