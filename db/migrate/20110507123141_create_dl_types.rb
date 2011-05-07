class CreateDlTypes < ActiveRecord::Migration
  def self.up
    create_table :dl_types do |t|
	  t.references :dl_type
      t.string :typename, :limit  => 64
      t.integer :type_lv, :limit  => 2

      t.timestamps
    end
	execute <<-SQL
      ALTER TABLE dl_types
        ADD CONSTRAINT fk_dltypes_parentdltypes
        FOREIGN KEY (dl_type_id)
        REFERENCES dl_types(id)
    SQL
  end

  def self.down
	execute "ALTER TABLE dl_types DROP FOREIGN KEY fk_dltypes_parentdltypes"
    drop_table :dl_types
  end
end
