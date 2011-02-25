class RecurringController < ApplicationController
  def every_hour
    PeerReview.start_feedbacks
    PeerReview.finish
  end
  
  def every_day
    
  end
  
end
