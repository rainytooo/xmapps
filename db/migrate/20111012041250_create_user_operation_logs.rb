class CreateUserOperationLogs < ActiveRecord::Migration
  def change
    create_table :user_operation_logs do |t|
      t.references :user
      t.integer :dz_user_id
      t.string :username, :limit => 32  #�û���
      t.string :app, :limit => 32  #
      t.integer :action_time    #����ʱ��
      t.timestamps
    end
    execute <<-SQL
        ALTER TABLE user_operation_logs
          ADD CONSTRAINT fk_user_operation_logs_user
          FOREIGN KEY (user_id)
          REFERENCES users(id)
    SQL
  end
end
