class Source < ActiveRecord::Base
  belongs_to :user,:class_name => "User"
  belongs_to :source_type,:class_name => "SourceType"
  belongs_to :source_lang,:class_name => "SourceLang"

  has_attached_file :photo,
		:styles => { :medium => "300x300>", :thumb => "100x100>" },
		:processors => [:cropper],
		:url => "#{DOWNLOAD_THREAD_PHOTO_ROOT_URL}/sources/:attachment/:year/:month/:day/:id/:style/:filename",
		:path => "#{DOWNLOAD_THREAD_PHOTO_ROOT_PATH}/sources/:attachment/:year/:month/:day/:id/:style/:filename",
		:use_timestamp         => true
end

