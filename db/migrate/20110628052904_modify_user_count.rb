class ModifyUserCount < ActiveRecord::Migration
  def self.up
    add_column :user_counts, :app_name, :string, :default => "dl", :limit => 20
  end

  def self.down
    remove_column :user_counts, :app_name
  end
end

