class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.string :name
      t.string :title
      t.text :desc_content
      t.string :addr
      t.datetime :start_date

      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
