class PeerReview < ActiveRecord::Base
  has_many :peer_review_assignments
  has_many :users, :through => :peer_review_assignments
  has_many :peer_review_solutions, :through => :peer_review_assignments
  has_many :peer_review_feedbacks, :through => :peer_review_assignments
  
  validates_presence_of :title, :task, :number_of_feedbacks
  
  validates :email, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}  
  
  validate :timeliness_given
  
  #MODEL Methods
  #################
  
  def status
    if finished
      "finished"
    elsif reviewing?
      "reviewing"
    elsif started?
      "started"
    else
      "not started"
    end
  end
  
  def start_feedbacks?
    if peer_review_assignments.length == peer_review_solutions.length #start feedbacks when all solutions are in.
      self.start_feedbacks
    end
  end
  
  def start_feedbacks
    @peer_review = PeerReview.find(id)
    @peer_review.reviewing = true
    @peer_review.save
    
    @solutions = @peer_review.peer_review_solutions.all
    
    
    @solutions.each_with_index do |solution, i|
      @assignment = @solutions[i].peer_review_assignment
      @user = @assignment.user
      PeerReviewMailer.feedback_assignment(@assignment, @peer_review, @user).deliver
      
      @peer_review.number_of_feedbacks.downto(1) do |n|
        n=(i+n) % @solutions.count
        @feedback = PeerReviewFeedback.create([:peer_review_assignment => @assignment, :peer_review_solution => @solutions[n]])
      end
    end
    
    PeerReviewMailer.status(@peer_review).deliver
    
  end
  
  def check_if_feedback_is_complete
    @feedbacks = self.peer_review_feedbacks.where(:text => nil)
    unless self.finished == true
      if @feedbacks.count <= 1 or feedback_due <= Time.now
        PeerReviewMailer.status(self).deliver
        self.finished = true
        self.save
        self.peer_review_solutions.where(:feedback_returned => false).each do |solution|
          solution.return_feedback
        end
      end
    end
  end
  
  
  
  #CLASS Methods
  #################
  
  def self.finish 
    self.where(:finished => false).each do |pr|
      pr.check_if_feedback_is_complete
    end
  end
  
  def self.start_feedbacks
    self.where(:reviewing => false).each do |pr|
      if pr.peer_review_solutions.count == pr.peer_review_assignments.count
        pr.start_feedbacks
      elsif pr.solution_due <= Time.now
        pr.start_feedbacks
      end
    end
  end
  
  
  protected 
  
  
  def timeliness_given
    errors.add(:solution_due, 'should be in the future') if solution_due.nil? || solution_due < Time.now
    errors.add(:feedback_due, 'should be after due date of solution') if feedback_due.nil? || feedback_due < solution_due
  end
  

end
