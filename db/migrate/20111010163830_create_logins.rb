class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.string :username, :limit  => 32
      t.string :password, :limit  => 32    
    end
  end
end
