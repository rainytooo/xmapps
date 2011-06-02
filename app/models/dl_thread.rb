class DlThread < ActiveRecord::Base
  	belongs_to :user,:class_name => "User"
	belongs_to :dl_type,:class_name => "DlType"
	
	#表单的客户端验证
	validates_presence_of :name
	validates_length_of :name, :minimum => 5
	validates_length_of :name, :maximum => 128
	#validates_presence_of :photo
	validates_presence_of :content_desc
	#validates_length_of :content_desc, :minimum => 20
	#validates_length_of :content_desc, :maximum => 255
	#validates_presence_of :content
	
	
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
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :message => "文件类型不符合要求,只能上传jpeg,gif,png格式的图片"
	# 小于1M
	validates_attachment_size :photo, :less_than => 1.megabyte, :message => "文件大小超出限制"
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
