# ÎÊ´ðµÄ´ð°¸
class CreateAskAnswers < ActiveRecord::Migration
  def self.up
    create_table :ask_answers do |t|
	    t.references :ask
	    t.references :user
	    t.string :username , :limit => 32
	    t.integer :badrate ,:limit  => 10, :default => 0
	    t.integer :goodrate ,:limit  => 10, :default => 0
	    t.text :content
	    t.integer :ifcheck, :limit  => 1, :default => 0
      t.timestamps
    end
	execute <<-SQL
      ALTER TABLE ask_answers
        ADD CONSTRAINT fk_answers_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    SQL

	execute <<-SQL
      ALTER TABLE ask_answers
        ADD CONSTRAINT fk_answers_ask
        FOREIGN KEY (ask_id)
        REFERENCES asks(id)
    SQL
  end

  def self.down
	execute "ALTER TABLE ask_answers DROP FOREIGN KEY fk_answers_user"
	execute "ALTER TABLE ask_answers DROP FOREIGN KEY fk_answers_ask"
    drop_table :ask_answers
  end
end

