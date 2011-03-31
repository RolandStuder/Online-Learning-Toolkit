class PeerReviewAssignmentsController < ApplicationController
  def create
    @peer_review = PeerReview.find(params[:peer_review_id])
    @assignment = @peer_review.peer_review_assignments.create(params[:peer_review_assignment])
    redirect_to peer_review_path(@peer_review)
  end
  
  def index
      @peer_review = PeerReview.find(params[:peer_review_id])
      @assignments = @peer_review.peer_review_assignments.all
  end
  
  def show
    @assignment = PeerReviewAssignment.find(params[:id])
    @peer_review = @assignment.peer_review
    @feedbacks = @assignment.peer_review_feedbacks.all
    
    @solution_none = true
    @solution_present = false
    @solution_late = false
    
    @feedback_started = false
    @feedback_needed = false
    @feedback_given = false
        
    @feedback_received = false
    
    @feedback_started = true   if @peer_review.reviewing?
    

    if @solution = @assignment.peer_review_solutions.first
      @solution_none = false
      @solution_present = true   unless @solution.text.nil?
      
      @received_feedbacks = @assignment.peer_review_solutions.first.peer_review_feedbacks.all
        
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
    
    
    
    
    
  end
  
end
