class AddFeedbackReturnedToPeerReviewSolution < ActiveRecord::Migration
  def self.up
    add_column :peer_review_solutions, :feedback_returned, :boolean, :default => false
  end

  def self.down
    remove_column :peer_review_solutions, :feedback_returned
  end
end
