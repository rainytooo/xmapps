# ฮสด๐ึ๗ฑํ
class Ask < ActiveRecord::Base
  belongs_to :user,:class_name => "User"
	belongs_to :ask_type,:class_name => "AskType"

  validates(:title, :presence => true, :length => {:in => 10..128})
  #validates_confirmation_of :title
  #validates_presence_of :content
  #validates_length_of :content, :minimum => 20
end

