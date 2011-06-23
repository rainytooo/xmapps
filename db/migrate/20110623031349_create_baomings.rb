class CreateBaomings < ActiveRecord::Migration
  def self.up
    create_table :baomings do |t|
      t.string :name ,:limit  => 32
      t.string :telnum ,:limit  => 32
      t.string :school,:limit  => 32
      t.integer :age,:limit  => 3
      t.string :city,:limit  => 32
      t.string :zhuanye,:limit  => 32
      t.string :tuofucj,:limit  => 32
      t.string :baokaoxuexiao,:limit  => 64
      t.string :campaign,:limit  => 64
      t.timestamps
    end
  end

  def self.down
    drop_table :baomings
  end
end

