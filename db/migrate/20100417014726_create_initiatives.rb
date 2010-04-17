class CreateInitiatives < ActiveRecord::Migration
  def self.up
    create_table :initiatives do |t|
      t.integer :number
      t.integer :legislation
      t.text :description
      t.string :type
      t.string :state
      t.date :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :initiatives
  end
end
