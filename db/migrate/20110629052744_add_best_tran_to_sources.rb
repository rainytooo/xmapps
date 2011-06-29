class AddBestTranToSources < ActiveRecord::Migration
  def self.up
    add_column :sources, :best_trans_id, :integer
    add_column :sources, :best_trans_userid,  :integer
    add_column :sources, :best_trans_username, :string
    add_column :sources, :best_trans_userdzid, :integer
  end

  def self.down
    remove_column :sources, :best_trans_id
    remove_column :sources, :best_trans_userid
    remove_column :sources, :best_trans_username
    remove_column :sources, :best_trans_userdzid
  end
end

