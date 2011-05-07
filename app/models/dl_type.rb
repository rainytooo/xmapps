class DlType < ActiveRecord::Base	
	has_many :child_dltype,:class_name => "DlType",:foreign_key => "dl_type_id"
	belongs_to :dl_type,:class_name => "DlType"
end
