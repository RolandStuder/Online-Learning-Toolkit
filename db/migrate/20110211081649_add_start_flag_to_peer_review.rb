class AddStartFlagToPeerReview < ActiveRecord::Migration
  def self.up
    add_column :peer_reviews, :started, :boolean, :default => false
  end

  def self.down
    remove_column :peer_reviews, :started
  end
end
