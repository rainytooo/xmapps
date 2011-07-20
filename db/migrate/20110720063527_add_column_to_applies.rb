class AddColumnToApplies < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :campany, :string, :limit => 64
    add_column :campaigns, :diqu_code, :string, :limit => 32, :default => '010'
    add_column :applies, :campany, :string, :limit => 64
    add_column :applies, :diqu_code, :string, :limit => 32, :default => '010'
  end

  def self.down
    remove_column :campaigns, :campany
    remove_column :campaigns, :diqu_code
    remove_column :applies, :campany
    remove_column :applies, :diqu_code
  end
end

