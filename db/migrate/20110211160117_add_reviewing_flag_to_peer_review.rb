class AddReviewingFlagToPeerReview < ActiveRecord::Migration
  def self.up
    add_column :peer_reviews, :reviewing, :boolean, :default => false
  end

  def self.down
    remove_column :peer_reviews, :reviewing
  end
end
