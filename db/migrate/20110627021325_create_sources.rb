class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.references :user
      t.references :source_type
      t.references :source_lang
      t.integer :dz_user_id
      #t.integer :source_type  # 原文种类 1科技 2文化 3体育 4生活 5八卦 6社会 0其他
      #t.integer :origin_lang  # 原文的语言种类  1英语 2德语 3法语 4西班牙语 5意大利语 6日语 7韩语 8俄语 9葡语 0其他
      t.string :username, :limit => 32  #用户名
      t.string :title, :limit => 255  #标题
      t.string :source_desc, :limit => 255 # 原文简介
      t.string :origin_url, :limit => 255 #原文链接
      t.text :content #内容
      t.string :photo_file_name, :limit => 128
      t.string :photo_content_type, :limit => 32
      t.integer :photo_file_size
      t.integer :views, :default => 0  #浏览次数
      t.integer :status, :default => 1 #状态 0 未通过 1 已通过 2 已翻译
      t.timestamps
    end
    execute <<-SQL
        ALTER TABLE sources
          ADD CONSTRAINT fk_sources_user
          FOREIGN KEY (user_id)
          REFERENCES users(id)
    SQL
    execute <<-SQL
        ALTER TABLE sources
          ADD CONSTRAINT fk_sources_lang
          FOREIGN KEY (source_lang_id)
          REFERENCES source_langs(id)
    SQL
    execute <<-SQL
        ALTER TABLE sources
          ADD CONSTRAINT fk_sources_type
          FOREIGN KEY (source_type_id)
          REFERENCES source_types(id)
    SQL
  end

  def self.down
    execute "ALTER TABLE sources DROP FOREIGN KEY fk_sources_user"
    execute "ALTER TABLE sources DROP FOREIGN KEY fk_sources_lang"
    execute "ALTER TABLE sources DROP FOREIGN KEY fk_sources_type"
    drop_table :sources
  end
end

