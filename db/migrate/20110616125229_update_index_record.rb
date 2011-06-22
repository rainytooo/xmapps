class UpdateIndexRecord < ActiveRecord::Migration
  def self.up
    create_table :update_index_record do |t|
	    t.integer :last_update ,:limit  => 10
    end
    execute <<-SQL
      INSERT INTO `xmapps_development`.`update_index_record` (
        `id` , `last_update`) VALUES ('1', '0')
    SQL
  end

  def self.down
    drop_table :update_index_record
  end
end

