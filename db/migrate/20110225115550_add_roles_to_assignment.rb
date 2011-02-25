class AddRolesToAssignment < ActiveRecord::Migration
  def self.up
    add_column :peer_review_assignments, :admin, :boolean, :default => false
    add_column :peer_review_assignments, :participant, :boolean, :default => false
    remove_column :peer_review_assignments, :role
  end

  def self.down
    remove_column :peer_review_assignments, :admin
    remove_column :peer_review_assignments, :participant
  end
end
