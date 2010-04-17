class CreateInterventions < ActiveRecord::Migration
  def self.up
    create_table :interventions do |t|
      t.integer :parliament_member_id
      t.text :words_json
      t.date :date
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :interventions
  end
end
