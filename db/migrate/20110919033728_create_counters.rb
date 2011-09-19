class CreateCounters < ActiveRecord::Migration
  def self.up
    create_table :counters do |t|
    t.string :campaign, :limit => 64
    t.integer :total_count, :limit => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :counters
  end
end

