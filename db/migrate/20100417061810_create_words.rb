class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.string :stem
      t.string :pos
      t.string :literal
      t.string :lemma
      t.date :date
      t.integer :count
      t.boolean :representative
      t.timestamps
    end
  end

  def self.down
    drop_table :words
  end
end
