class CreateSourceTypes < ActiveRecord::Migration
  def self.up
    create_table :source_types do |t|
      t.string :name
    end
    execute <<-SQL
      INSERT INTO `source_types` (`id`, `name`) VALUES
		    (1, '科技'),
		    (2, '文化'),
		    (3, '体育'),
		    (4, '生活'),
		    (5, '八卦'),
		    (6, '社会'),
		    (99, '其他')
    SQL
  end

  def self.down
    drop_table :source_types
  end
end

