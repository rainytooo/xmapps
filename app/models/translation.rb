class Translation < ActiveRecord::Base
  belongs_to :user,:class_name => "User"
  belongs_to :source,:class_name => "Source"
  belongs_to :source_type,:class_name => "SourceType"
  belongs_to :source_lang,:class_name => "SourceLang"
end

