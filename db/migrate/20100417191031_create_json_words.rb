class CreateJsonWords < ActiveRecord::Migration
  def self.up
    create_table :parliament_member_words do |t|
      t.integer :parliament_member_id
      t.string :stem
      t.string :pos
      t.string :literal
      t.string :lemma
      t.date :date
      t.integer :count
      t.boolean :representative
      t.timestamps
    end
    create_table :intervention_words do |t|
      t.integer :intervention_id
      t.string :stem
      t.string :pos
      t.string :literal
      t.string :lemma
      t.date :date
      t.integer :count
      t.boolean :representative
      t.timestamps
    end
    create_table :session_words do |t|
      t.integer :session_id
      t.string :stem
      t.string :pos
      t.string :literal
      t.string :lemma
      t.date :date
      t.integer :count
      t.boolean :representative
      t.timestamps
    end
    remove_column :sessions, :words_json
    remove_column :interventions, :words_json
    remove_column :parliament_members, :words_json
  end

  def self.down
    add_column :sessions, :words_json, :blob
    add_column :interventions, :words_json, :blob
    add_column :parliament_members, :words_json, :blob
    drop_table :session_words
    drop_table :intervention_words
    drop_table :parliament_member_words
  end
end
