class CreateDlThreads < ActiveRecord::Migration
  def self.up
    create_table :dl_threads do |t|
	  #t.references :dl_image
	  t.references :dl_type
	  t.references :user
      t.string :name ,:limit  => 128
      t.text :content 
      t.integer :createtime ,:limit  => 10
      t.integer :ispass ,:limit  => 2, :default => 0

      t.timestamps
    end
	execute <<-SQL
      ALTER TABLE dl_threads
        ADD CONSTRAINT fk_dlthreads_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    SQL
	execute <<-SQL
      ALTER TABLE dl_threads
        ADD CONSTRAINT fk_dlthreads_dltype
        FOREIGN KEY (dl_type_id)
        REFERENCES dl_types(id)
    SQL
	# execute <<-SQL
      # ALTER TABLE dl_threads
        # ADD CONSTRAINT fk_dlthreads_dlimage
        # FOREIGN KEY (dl_image_id)
        # REFERENCES dl_images(id)
    # SQL
  end

  def self.down
	execute "ALTER TABLE dl_threads DROP FOREIGN KEY fk_dlthreads_user"
	execute "ALTER TABLE dl_threads DROP FOREIGN KEY fk_dlthreads_dltype"
	#execute "ALTER TABLE dl_threads DROP FOREIGN KEY fk_dlthreads_dlimage"
    drop_table :dl_threads
  end
end
