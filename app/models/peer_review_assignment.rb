class PeerReviewAssignment < ActiveRecord::Base
  belongs_to :peer_review
  belongs_to :user
  has_many :peer_review_solutions
  has_many :peer_review_feedbacks
  
  validates_presence_of :peer_review, :user
  validates_uniqueness_of :peer_review_id, :scope => :user_id
  
  def status
    @peer_review = self.peer_review
    @feedbacks = self.peer_review_feedbacks.all
    
    @solution_none = true
    @solution_present = false
    @solution_late = false
    
    @feedback_started = false
    @feedback_needed = false
    @feedback_given = false
        
    @feedback_received = false
    
    @feedback_started = true   if @peer_review.reviewing?
    

    if @solution = self.peer_review_solutions.first
      @solution_none = false
      @solution_present = true   unless @solution.text.nil?
      
      @received_feedbacks = self.peer_review_solutions.first.peer_review_feedbacks.all
        
      @received_count = 0  
      @solution.peer_review_feedbacks.all.each do |f|
        @received_count += 1 unless f.text.nil?
      end
      
      @given_count = 0
      @feedbacks.each do |feedback|
        @given_count += 1 unless feedback.text.nil? 
      end
      
      
      @feedback_needed = true    if @given_count < @peer_review.number_of_feedbacks
      @feedback_given = true     if @given_count == @peer_review.number_of_feedbacks      
      
      if @feedback_given == true
        @feedback_received = true if @received_count == @peer_review.number_of_feedbacks
      end
      
    elsif @peer_review.reviewing?
      @solution_late = true
    end
    
    if @feedback_received == true
      return 'feedback_received'
    elsif @feedback_given == true
      return 'feedback_given'
    elsif @feedback_started == true
      return 'feedback_assigned'
    elsif @solution_present == true
      return 'solution_submitted'
    else
      return 'assigned'
    end
    
    
  end
  
  #states an assignment can have
  # 1. assigned
  # 2. solution_submitted
  # 3. feedback_assigned
  # 4. feedback_given
  # 5. feedback_received
  
  
  
end
