class CreatePeerReviews < ActiveRecord::Migration
  def self.up
    create_table :peer_reviews do |t|
      t.string :title
      t.text :task
      t.datetime :solution_due
      t.text :feedback_instructions
      t.datetime :feedback_due
      t.string :email
      t.integer :number_of_feedbacks

      t.timestamps
    end
  end

  def self.down
    drop_table :peer_reviews
  end
end
