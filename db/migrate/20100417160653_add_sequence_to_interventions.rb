class AddSequenceToInterventions < ActiveRecord::Migration
  def self.up
    add_column :interventions, :sequence, :integer
  end

  def self.down
    remove_column :interventions, :sequence
  end
end
