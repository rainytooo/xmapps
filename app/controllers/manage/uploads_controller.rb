# �����ϴ����������
class Manage::UploadsController < ApplicationController
  before_filter :require_login
  
  def index
	#  ��ѯ��ҳ,�ҵ��ϴ�
	@dl_threads = DlThread.where("user_id = ?", session[:login_user].id).paginate(:page=>params[:page]||1,:per_page=>10)
  end

end
