class CreateLogins < ActiveRecord::Migration
  def self.up
    create_table :logins do |t|
      t.string :username, :limit  => 32
      t.string :password, :limit  => 32      
    end
  end

  def self.down
    drop_table :logins
  end
end
