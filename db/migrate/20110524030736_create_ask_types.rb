# 问答的类型
class CreateAskTypes < ActiveRecord::Migration
  def self.up
    create_table :ask_types do |t|
	  t.string :name, :limit => 32
	  t.integer :pid, :limit => 10, :default => 0
	  t.integer :disorder, :limit => 10, :default => 0
	  t.integer :asksnum, :limit => 10, :default => 0
      t.timestamps
    end
	execute <<-SQL
      INSERT INTO `ask_types` (`id`, `name`, `pid`, `disorder`,`asksnum`,`created_at`, `updated_at`) VALUES
		(1, '托福', 0, 0, 0, '2011-05-16 02:16:38', '2011-05-16 02:16:38'),
		(2, '雅思', 0, 0, 0, '2011-05-16 02:16:38', '2011-05-16 02:16:38'),
		(3, 'GRE', 0, 0, 0, '2011-05-16 02:16:38', '2011-05-16 02:16:38'),
		(4, 'GMAT', 0, 0, 0, '2011-05-16 02:16:38', '2011-05-16 02:16:38'),
		(5, 'SAT', 0, 0, 0, '2011-05-16 02:16:38', '2011-05-16 02:16:38'),
		(6, '出国留学', 0, 0, 0, '2011-05-16 02:16:38', '2011-05-16 02:16:38')
    SQL
  end

  def self.down
    drop_table :ask_types
  end
end
