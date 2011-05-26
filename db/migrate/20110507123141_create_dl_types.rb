class CreateDlTypes < ActiveRecord::Migration
  def self.up
    create_table :dl_types do |t|
	  t.references :dl_type
      t.string :typename, :limit  => 64
      t.integer :type_lv, :limit  => 2, :default => 0

      t.timestamps
    end
	execute <<-SQL
      ALTER TABLE dl_types
        ADD CONSTRAINT fk_dltypes_parentdltypes
        FOREIGN KEY (dl_type_id)
        REFERENCES dl_types(id)
    SQL
	
	execute <<-SQL
      INSERT INTO `dl_types` (`id`, `dl_type_id`, `typename`, `type_lv`, `created_at`, `updated_at`) VALUES
		(1, NULL, 'root', 0, '2011-05-16 02:16:38', '2011-05-16 02:16:38'),
		(2, 1, '英语学习资料', 1, '2011-05-16 02:16:55', '2011-05-16 02:16:55'),
		(3, 2, '托福', 2, '2011-05-16 02:17:07', '2011-05-16 02:17:07'),
		(4, 2, '雅思', 2, '2011-05-16 02:17:14', '2011-05-16 02:17:14'),
		(5, 2, 'SAT', 2, '2011-05-16 02:17:23', '2011-05-16 02:17:23'),
		(6, 3, '托福听力', 3, '2011-05-16 02:17:44', '2011-05-16 02:17:44'),
		(7, 3, '托福阅读', 3, '2011-05-16 02:17:54', '2011-05-16 02:17:54'),
		(8, 2, '工具软件', 2, '2011-05-16 02:18:19', '2011-05-16 02:18:19'),
		(9, 2, '有声读物', 2, '2011-05-16 02:20:59', '2011-05-16 02:20:59'),
		(10, 3, '托福口语', 3, '2011-05-16 02:22:49', '2011-05-16 02:22:49'),
		(11, 3, '托福写作', 3, '2011-05-16 02:23:06', '2011-05-16 02:23:06'),
		(12, 3, '托福综合', 3, '2011-05-16 02:24:03', '2011-05-16 02:24:03'),
		(13, 2, '小马过河备考听力包', 2, '2011-05-16 02:24:03', '2011-05-16 02:24:03')
    SQL
  end

  def self.down
	execute "ALTER TABLE dl_types DROP FOREIGN KEY fk_dltypes_parentdltypes"
    drop_table :dl_types
  end
end
