class CreateTranRanks < ActiveRecord::Migration
  def self.up
    create_table :tran_ranks do |t|
      t.references :user
      t.integer :dz_user_id
      t.string :username, :limit => 32  #用户名
      t.string :campaign, :limit => 32  #用户名
      t.integer :total_trans, :limit => 5, :default => 0 #翻译总数
      t.integer :best_trans,:limit => 5, :default => 0 #最佳翻译总数
      t.integer :total_excredits ,:limit => 10, :default => 0 #总金币数
      t.timestamps
    end
    execute <<-SQL
        ALTER TABLE tran_ranks
          ADD CONSTRAINT fk_tran_ranks_user
          FOREIGN KEY (user_id)
          REFERENCES users(id)
    SQL
  end

  def self.down
    execute "ALTER TABLE tran_ranks DROP FOREIGN KEY fk_tran_ranks_user"
    drop_table :tran_ranks
  end
end

