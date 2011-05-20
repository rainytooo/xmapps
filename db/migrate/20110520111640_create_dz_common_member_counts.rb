class CreateDzCommonMemberCounts < ActiveRecord::Migration
  def self.up
    create_table :dz_common_member_counts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :dz_common_member_counts
  end
end
