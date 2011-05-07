class CreateDlAttachments < ActiveRecord::Migration
  def self.up
    create_table :dl_attachments do |t|
	  t.references :dl_thread
      t.string :filename, :limit  => 64
      t.integer :filesize ,:limit  => 10, :default => 0
      t.string :filepath ,:limit  => 255
	  t.integer :is_image, :limit  => 2, :default => 0
	  t.integer :donwloads, :limit  => 10, :default => 0
      t.timestamps
    end
	execute <<-SQL
      ALTER TABLE dl_attachments
        ADD CONSTRAINT fk_dlattachments_dlthread
        FOREIGN KEY (dl_thread_id)
        REFERENCES dl_threads(id)
    SQL
  end

  def self.down
	execute "ALTER TABLE dl_attachments DROP FOREIGN KEY fk_dlattachments_dlthread"
    drop_table :dl_attachments
  end
end
