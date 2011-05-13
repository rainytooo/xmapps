class DlThread < ActiveRecord::Base
  	belongs_to :user,:class_name => "User"
	belongs_to :dl_type,:class_name => "DlType"
	#belongs_to :dl_image,:class_name => "DlImage"
	has_attached_file :photo, 
		:styles => { :medium => "300x300>", :thumb => "100x100>" },
		:processors => [:cropper],
		:url => "#{DOWNLOAD_THREAD_PHOTO_ROOT_URL}/:attachment/:year/:month/:day/:id/:style/:filename",
		:path => "#{DOWNLOAD_THREAD_PHOTO_ROOT_PATH}/:attachment/:year/:month/:day/:id/:style/:filename",
		:use_timestamp         => true
	# 以下3个验证都可以添加message属性来返回错误	
	# 必填	
	#validates_attachment_presence :photo
	# 文件类型验证
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
	# 小于1M
	validates_attachment_size :photo, :less_than => 1.megabyte
	before_create :randomize_file_name
	
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	after_update :reprocess_photo, :if => :cropping?
	
	def cropping?
      !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
	end
	
	def photo_geometry(style = :original)
      @geometry ||= {}
      @geometry[style] ||= Paperclip::Geometry.from_file(photo.path(style))
	end
	
	private

	  def randomize_file_name
		extension = File.extname(photo_file_name).downcase
		self.photo.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
	  end
	  def reprocess_photo
		photo.reprocess!
	  end

end
