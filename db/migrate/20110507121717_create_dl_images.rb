class CreateDlImages < ActiveRecord::Migration
  def self.up
    create_table :dl_images do |t|
      t.string :filename, :limit  => 36
      t.integer :filesize, :limit  => 10
      t.string :filepath, :limit  => 255

      t.timestamps
    end
  end

  def self.down
    drop_table :dl_images
  end
end
