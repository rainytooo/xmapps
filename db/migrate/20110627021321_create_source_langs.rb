class CreateSourceLangs < ActiveRecord::Migration
  def self.up
    create_table :source_langs do |t|
      t.string :name
      t.timestamps
    end
    execute <<-SQL
    INSERT INTO `source_langs` (`id`, `name`) VALUES
		    (1, '英语'),
		    (2, '德语'),
		    (3, '法语'),
		    (4, '西班牙语'),
		    (5, '意大利语'),
		    (6, '日语'),
		    (7, '韩语'),
		    (8, '俄语'),
		    (9, '葡语'),
		    (99, '其他')
		SQL
  end

  def self.down
    drop_table :source_langs
  end
end

