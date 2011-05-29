class HomeController < ApplicationController
  def index
  end
  
  def robots
	robots = ROBOTS_TXT
    respond_to do |format|
      format.text { render :text => robots, :layout => false }
    end
  end
  # 页面无法找到
  def notfound
  end
  # 内部错误
  def errorpage
  end
end