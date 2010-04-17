class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.string :identifier
      t.text :content
      t.date :date
      t.text :words_json
      t.text :day_order
      t.text :interventions
      t.timestamps
    end

    add_column :interventions, :session_id, :string
  end

  def self.down
    drop_table :sessions
    remove_column :interventions, :session_id
  end
end
