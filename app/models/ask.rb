# �ʴ�����
class Ask < ActiveRecord::Base
  belongs_to :user,:class_name => "User"
	belongs_to :ask_type,:class_name => "AskType"

  #validates(:title, :presence => true, :length => {:in => 5..128})
  #validates(:content, :presence => true, :length => {:minimum => 10})

  # status 0 δ��� 1 �ѽ�� 2 �ѹر�(�ֶ�) 3 �ѹر�(�Զ�)
end

