class CreatePeerReviewSolutions < ActiveRecord::Migration
  def self.up
    create_table :peer_review_solutions do |t|
      t.text :text
      t.references :peer_review_assignment

      t.timestamps
    end
  end

  def self.down
    drop_table :peer_review_solutions
  end
end
