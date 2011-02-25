class CreatePeerReviewAssignments < ActiveRecord::Migration
  def self.up
    create_table :peer_review_assignments do |t|
      t.string :role
      t.references :peer_review
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :peer_review_assignments
  end
end
