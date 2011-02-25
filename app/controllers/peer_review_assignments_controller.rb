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
    
    @solution = @assignment.peer_review_solutions.first
  end
  
end
