class AddUuids < ActiveRecord::Migration
  def self.up
    add_column :interventions, :uuid, :string
    add_column :sessions, :uuid, :string
    add_column :words, :uuid, :string
    add_column :session_words, :uuid, :string
    add_column :intervention_words, :uuid, :string
    add_column :parliament_member_words, :uuid, :string
    add_column :parliament_members, :uuid, :string
  end

  def self.down
    remove_column :interventions, :uuid
    remove_column :sessions, :uuid
    remove_column :words, :uuid
    remove_column :session_words, :uuid
    remove_column :intervention_words, :uuid
    remove_column :parliament_member_words, :uuid
    remove_column :parliament_members, :uuid
  end
end
