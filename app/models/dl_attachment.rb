class DlAttachment < ActiveRecord::Base
	belongs_to :dl_thread,:class_name => "DlThread"
end
