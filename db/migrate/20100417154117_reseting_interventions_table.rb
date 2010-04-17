class ResetingInterventionsTable < ActiveRecord::Migration
  def self.up
    drop_table :interventions
    create_table :interventions do |t|
      t.integer :parliament_member_id
      t.text :words_json
      t.date :date
      t.text :content
      t.integer :session_id
      t.timestamps
    end
  end

  def self.down
  end
end
