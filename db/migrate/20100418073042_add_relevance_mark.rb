class AddRelevanceMark < ActiveRecord::Migration
  def self.up
    add_column :words, :relevant, :boolean
    add_column :session_words, :relevant, :boolean
    add_column :intervention_words, :relevant, :boolean
    add_column :parliament_member_words, :relevant, :boolean
  end

  def self.down
    remove_column :words, :relevant
    remove_column :session_words, :relevant
    remove_column :intervention_words, :relevant
    remove_column :parliament_member_words, :relevant
  end
end
