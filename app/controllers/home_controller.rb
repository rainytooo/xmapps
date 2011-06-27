class HomeController < ApplicationController
  def index
    # 取出最新的下载
    # 本周热门
	  date_after = Date.today - 14
	  @week_hot = DlThread.where("ispass = ? and created_at >= ?", 1, date_after).order("views DESC").order("created_at DESC").limit(10).offset(0)
	  # 最新免金币下载资源
    @free_dl = DlThread.where("ispass = 1").order("created_at DESC").limit(10).offset(0)
    # 最新问答
    @new_asks = Ask.order("created_at DESC").limit(10)
  end

  # def robots
	# robots = ROBOTS_TXT
    # respond_to do |format|
      # format.text { render :text => robots, :layout => false }
    # end
  # end
  # 页面无法找到
  def notfound
  end
  # 内部错误
  def errorpage
  end
end

