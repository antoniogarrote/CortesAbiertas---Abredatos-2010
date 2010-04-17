class FixingBadTypSessionId < ActiveRecord::Migration
  def self.up
    add_column :interventions, :session_id, :integer
  end

  def self.down
    add_column :interventions, :session_id, :integer
  end
end
