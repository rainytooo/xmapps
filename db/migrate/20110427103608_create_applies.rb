class CreateApplies < ActiveRecord::Migration
  def self.up
    create_table :applies do |t|
      t.string :name
      t.string :email
      t.string :mobile
      t.string :school
      t.integer :age
      t.string :city
      t.integer :campaign_req
      t.references :campaign

      t.timestamps
    end
  end

  def self.down
    drop_table :applies
  end
end
