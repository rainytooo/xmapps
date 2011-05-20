class CreateTagRelationships < ActiveRecord::Migration
  def self.up
    create_table :tag_relationships do |t|
	  t.integer :tag_id
	  t.integer :object_id
	  t.string :taxonomy ,:limit => 32
      t.timestamps
    end
	
  end

  def self.down
    drop_table :tag_relationships
  end
end
