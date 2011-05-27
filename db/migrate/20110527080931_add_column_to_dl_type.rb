class AddColumnToDlType < ActiveRecord::Migration
  def self.up
	add_column :dl_types, :keywords, :string, :limit => 64
	add_column :dl_types, :description, :string, :limit => 256
  end

  def self.down
	remove_column :dl_types, :keywords
	remove_column :products, :description
  end
end
