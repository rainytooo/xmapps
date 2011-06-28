class ModifyTranslation < ActiveRecord::Migration
  def self.up
    add_column :translations, :best_trans, :integer, :default => 0
    add_column :translations, :best_trans_score, :integer, :default => 0
  end

  def self.down
    remove_column :translations, :best_trans
    remove_column :translations, :best_trans_score
  end
end

