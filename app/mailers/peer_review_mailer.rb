class PeerReviewMailer < ActionMailer::Base
  default :from => "online.learning.toolkit@gmail.com"

  def setup (peer_review)
    @peer_review = peer_review
    @users = @peer_review.users.all
    @assignments = @peer_review.peer_review_assignments.all
    
    mail( :to => @peer_review.email,
          :subject => "You set up a new peer review: " + peer_review.title)
  end
  
  def participant_task (peer_review, assignment, user)
    @peer_review = peer_review
    @assignment = assignment
    mail( :to => user.email,
          :subject => "You have a new task: " + peer_review.title)
  end
  
  def feedback_assignment (assignment, peer_review, user)
    @assignment = assignment
    @peer_review = peer_review
    @user = user
    mail( :to => @user.email,
          :subject => "Please provide feedback for task: " + peer_review.title)
  end
  
  def status(peer_review)
    @peer_review = peer_review
    @users = @peer_review.users.all(:order => "email asc")
    @assignments = @peer_review.peer_review_assignments.all
    
    mail( :to => @peer_review.email,
          :subject => "Peer Review finished: " + @peer_review.title)
    
  end  
  
  def return_feedback(solution)
    @solution = solution
    @assignment = @solution.peer_review_assignment
    @peer_review = @assignment.peer_review
    @feedbacks = @solution.peer_review_feedbacks.all
    @user = @assignment.user
     
    mail( :to => @user.email,
          :subject => "Feedbacks for your solution to " + @peer_review.title)
    
  end
  
end
