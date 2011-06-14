class AddGoldToDlThreads < ActiveRecord::Migration
  def self.up
    add_column :dl_threads, :gold, :integer, :default => 5
    add_column :dl_threads, :level, :integer, :default => 0
  end

  def self.down
    remove_column :dl_threads, :gold
    remove_column :dl_threads, :level
  end
end

