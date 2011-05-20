class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
	  t.string :name, :limit => 32
	  t.string :slug, :limit => 64
	  t.integer :count, :limit => 10, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
