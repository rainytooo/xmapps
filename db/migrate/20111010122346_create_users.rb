class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
		t.string :username
		t.string :email
		t.string :passwd
		t.integer :dz_common_id
		t.integer :regdate
		t.timestamps
    end
  end
end
