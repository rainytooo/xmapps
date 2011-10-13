class CreateUserCounts < ActiveRecord::Migration
  def change
    create_table :user_counts do |t|
	  t.references :user
	  t.integer :uploads, :limit  => 10, :default => 0   
      t.timestamps
    end
	execute <<-SQL
      ALTER TABLE user_counts
        ADD CONSTRAINT fk_user_counts_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
    SQL
  end
end
