class CreateDlRecords < ActiveRecord::Migration
  def self.up
    create_table :dl_records do |t|
	  t.references :user
	  t.integer :thread_id ,:limit => 10
	  t.integer :extcredits ,:limit => 10
      t.timestamps
    end
	execute <<-SQL
      ALTER TABLE dl_records
        ADD CONSTRAINT fk_dl_records_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    SQL
  end

  def self.down
	execute "ALTER TABLE dl_records DROP FOREIGN KEY fk_dl_records_user"
    drop_table :dl_records
  end
end
