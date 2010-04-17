class AddBlobs < ActiveRecord::Migration
  def self.up
    change_column :sessions, :words_json, :binary
    change_column :interventions, :words_json, :binary
    change_column :parliament_members, :words_json, :binary
  end

  def self.down
    change_column :sessions, :words_json, :text
    change_column :interventions, :words_json, :text
    change_column :parliament_members, :words_json, :text
  end
end
