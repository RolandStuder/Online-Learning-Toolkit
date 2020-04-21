class User < ActiveRecord::Base
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }


  has_many :peer_reviews, :through => :peer_review_assignments
  has_many :peer_review_assignments
  has_many :peer_review_solutions, :through => :peer_review_assignments

end
