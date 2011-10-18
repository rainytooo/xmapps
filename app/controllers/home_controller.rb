class HomeController < ApplicationController
  layout "empty", :except => [:i_want_credits, :translation_match, :notfound, :errorpage]
  def index
   
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
    @translations = Translation.where("status != 1").order("created_at DESC").limit(20)
    # 文章总数
    @total_count = Source.where("status != 0").count
    # 译文总数
    @trans_total_count = Translation.count
    # 最佳译文总数
    @trans_best_total_count = Translation.where("status = 1").count
    # 排行榜
    @trans_rank = TranRank.where("campaign = 'dyjfyds' and total_excredits > 0 ").order("total_excredits DESC").limit(41)
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

