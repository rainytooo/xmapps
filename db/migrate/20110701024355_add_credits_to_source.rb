class AddCreditsToSource < ActiveRecord::Migration
  def self.up
    add_column :sources, :excredits, :integer, :default => 50

  end

  def self.down
    remove_column :sources, :excredits
  end
end

