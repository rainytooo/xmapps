class CreateQuestionnaires < ActiveRecord::Migration
  def self.up
    create_table :questionnaires do |t|
      t.string :name, :limit => 64
      t.integer :gender, :limit => 3
      t.integer :age, :limit => 3
      t.string :school, :limit => 128
      t.string :subject, :limit => 128
      t.string :telnum, :limit => 12
      t.integer :liuxue_plan, :limit => 3
      t.references :user
      t.timestamps
    end
    execute <<-SQL
        ALTER TABLE questionnaires
          ADD CONSTRAINT fk_questionnaires_user
          FOREIGN KEY (user_id)
          REFERENCES users(id)
    SQL
  end

  def self.down
    execute "ALTER TABLE questionnaires DROP FOREIGN KEY fk_questionnaires_user"
    drop_table :questionnaires
  end
end

