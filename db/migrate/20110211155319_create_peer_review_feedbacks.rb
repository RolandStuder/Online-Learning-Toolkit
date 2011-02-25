class CreatePeerReviewFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :peer_review_feedbacks do |t|
      t.text :text
      t.references :peer_review_assignment
      t.references :peer_review_solution

      t.timestamps
    end
  end

  def self.down
    drop_table :peer_review_feedbacks
  end
end
