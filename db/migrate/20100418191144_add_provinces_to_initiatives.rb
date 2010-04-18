class AddProvincesToInitiatives < ActiveRecord::Migration
  def self.up
    add_column :initiatives, :province, :string
  end

  def self.down
    remove_column :initiatives, :province
  end
end
