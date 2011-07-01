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
    # 最新国外原文
    @sources = Source.where("status != 0").order("created_at DESC").limit(10)
    # 最新译文
    @translations = Translation.order("created_at DESC").limit(10)
    # 最新已关闭问答
    @solved_asks = Ask.where("status = 1").order("created_at DESC").limit(10)
  end

  # 赚金币
  def i_want_credits
      # 未关闭的问题
      @unsolve_asks = Ask.where("status = 0").order("created_at DESC").limit(10)
      # 未翻译的文章
      @sources = Source.where("status = 1").order("created_at DESC").limit(10)

  end

  # 翻译大赛
  def translation_match
    # 所有未翻译的文章
    @sources = Source.where("status = 1").order("created_at DESC").limit(20)
    # 翻译的文章
    @translations = Translation.order("created_at DESC").limit(20)
    # 文章总数
    @total_count = Source.where("status != 0").count
    # 译文总数
    @trans_total_count = Translation.count
    # 最佳译文总数
    @trans_best_total_count = Translation.where("status = 1").count
    # 排行榜
    @trans_rank = TranRank.where("campaign = 'dyjfyds' and total_excredits > 0").order("total_excredits DESC").limit(30)
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

