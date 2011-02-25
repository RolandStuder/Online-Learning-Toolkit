class AddFinishedToPeerReview < ActiveRecord::Migration
  def self.up
    add_column :peer_reviews, :finished, :boolean, :default => false
  end

  def self.down
    remove_column :peer_reviews, :finished
  end
end
