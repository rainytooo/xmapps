class CreateZhuantiIndices < ActiveRecord::Migration
  def self.up
    create_table :zhuanti_indices do |t|
      t.string :title ,:limit  => 128
      t.string :content_desc ,:limit  => 512
      t.text :content,:limit  => 32
      t.string :campaign,:limit  => 32
      t.string :url,:limit  => 128
      t.integer :index_id,:limit  => 2, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :zhuanti_indices
  end
end

