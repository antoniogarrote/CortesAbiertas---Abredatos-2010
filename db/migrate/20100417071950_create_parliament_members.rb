class CreateParliamentMembers < ActiveRecord::Migration
  def self.up
    create_table :parliament_members do |t|
      t.string :name
      t.text :words_json
      t.timestamps
    end
  end

  def self.down
    drop_table :parliament_members
  end
end
