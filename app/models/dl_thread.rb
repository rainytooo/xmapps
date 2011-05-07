class DlThread < ActiveRecord::Base
  	belongs_to :user,:class_name => "User"
	belongs_to :dl_type,:class_name => "DlType"
	belongs_to :dl_image,:class_name => "DlImage"
end
