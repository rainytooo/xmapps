class CreateTransComments < ActiveRecord::Migration
  def self.up
    create_table :trans_comments do |t|
      t.references :user
      t.references :translation
      t.string :username, :limit => 32  #用户名
      t.integer :dz_user_id
      t.string :content, :limit => 2000 #点评内容
      t.timestamps
    end
    execute <<-SQL
        ALTER TABLE trans_comments
          ADD CONSTRAINT fk_trans_comments_user
          FOREIGN KEY (user_id)
          REFERENCES users(id)
    SQL
    execute <<-SQL
        ALTER TABLE trans_comments
          ADD CONSTRAINT fk_trans_comments_trans
          FOREIGN KEY (translation_id)
          REFERENCES translations(id)
    SQL
  end

  def self.down
    execute "ALTER TABLE trans_comments DROP FOREIGN KEY fk_trans_comments_user"
    execute "ALTER TABLE trans_comments DROP FOREIGN KEY fk_trans_comments_trans"
    drop_table :trans_comments
  end
end

