class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.references :user
      t.references :source
      t.references :source_type
      t.references :source_lang
      t.integer :dz_user_id
      t.string :username, :limit => 32  #用户名
      t.string :title, :limit => 255  #标题
      t.string :source_desc, :limit => 255 # 原文简介
      t.string :origin_url, :limit => 255 #原文链接
      t.text :content #内容
      t.integer :trans_good, :default => 0 # 好评
      t.integer :trans_bad, :default => 0 # 差评
      t.integer :status, :default => 0 # 最佳翻译
      t.integer :views, :default => 0  #浏览次数
      t.timestamps
    end
    execute <<-SQL
        ALTER TABLE translations
          ADD CONSTRAINT fk_translations_user
          FOREIGN KEY (user_id)
          REFERENCES users(id)
    SQL
    execute <<-SQL
        ALTER TABLE translations
          ADD CONSTRAINT fk_translations_source
          FOREIGN KEY (source_id)
          REFERENCES sources(id)
    SQL
    execute <<-SQL
        ALTER TABLE translations
          ADD CONSTRAINT fk_translations_lang
          FOREIGN KEY (source_lang_id)
          REFERENCES source_langs(id)
    SQL
    execute <<-SQL
        ALTER TABLE translations
          ADD CONSTRAINT fk_translations_type
          FOREIGN KEY (source_type_id)
          REFERENCES source_types(id)
    SQL
  end

  def self.down
    execute "ALTER TABLE translations DROP FOREIGN KEY fk_translations_user"
    execute "ALTER TABLE translations DROP FOREIGN KEY fk_translations_source"
    execute "ALTER TABLE translations DROP FOREIGN KEY fk_translations_lang"
    execute "ALTER TABLE translations DROP FOREIGN KEY fk_translations_type"
    drop_table :translations
  end
end

