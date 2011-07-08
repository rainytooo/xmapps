class CreateUserOperationLogs < ActiveRecord::Migration
  def self.up
    create_table :user_operation_logs do |t|
      t.references :user
      t.integer :dz_user_id
      t.string :username, :limit => 32  #用户名
      t.string :app, :limit => 32  #
      t.integer :action_time    #操作时间
      t.timestamps
    end
    execute <<-SQL
        ALTER TABLE user_operation_logs
          ADD CONSTRAINT fk_user_operation_logs_user
          FOREIGN KEY (user_id)
          REFERENCES users(id)
    SQL
  end

  def self.down
    execute "ALTER TABLE user_operation_logs DROP FOREIGN KEY fk_user_operation_logs_user"
    drop_table :user_operation_logs
  end
end

