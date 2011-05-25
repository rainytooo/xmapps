class CreateAsks < ActiveRecord::Migration
  def self.up
    create_table :asks do |t|
	  t.references :user
	  t.references :ask_type
	  t.string :typename ,:limit  => 128
	  t.string :title ,:limit  => 128
	  t.integer :expiredtime ,:limit  => 10
	  t.integer :solvetime, :limit  => 10
	  t.integer :bestanswer, :limit  => 10
	  t.integer :bestanswer_uid, :limit  => 10
	  t.string :bestanswer_username, :limit  => 32
	  t.integer :status, :limit  => 1, :default => 0
	  t.integer :views, :limit  => 10, :default => 0
	  t.integer :replies, :limit  => 10, :default => 0
	  t.text :content
      t.timestamps
    end
	execute <<-SQL
      ALTER TABLE asks
        ADD CONSTRAINT fk_asks_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    SQL
	execute <<-SQL
      ALTER TABLE asks
        ADD CONSTRAINT fk_asks_type
        FOREIGN KEY (ask_type_id)
        REFERENCES ask_types(id)
    SQL
  end

  def self.down
	execute "ALTER TABLE asks DROP FOREIGN KEY fk_asks_user"
	execute "ALTER TABLE asks DROP FOREIGN KEY fk_asks_type"
    drop_table :asks
  end
end