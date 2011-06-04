# 问答主表
class Ask < ActiveRecord::Base
  belongs_to :user,:class_name => "User"
	belongs_to :ask_type,:class_name => "AskType"

  #validates(:title, :presence => true, :length => {:in => 5..128})
  #validates(:content, :presence => true, :length => {:minimum => 10})

  # status 0 未解决 1 已解决 2 已关闭(手动) 3 已关闭(自动)
end

