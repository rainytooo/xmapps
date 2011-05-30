class CreateSearchKeywords < ActiveRecord::Migration
  def self.up
    create_table :search_keywords do |t|
	  t.references :user
	  t.string :keywords ,:limit  => 128
	  t.string :appname ,:limit  => 32
      t.timestamps
    end
	execute <<-SQL
      ALTER TABLE search_keywords
        ADD CONSTRAINT fk_search_keywords_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    SQL
  end

  def self.down
	execute "ALTER TABLE search_keywords DROP FOREIGN KEY fk_search_keywords_user"
    drop_table :search_keywords
  end
end
