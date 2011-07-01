class TranslationsController < ApplicationController
  before_filter :require_login , :except => [:index, :show]
  # GET /translations
  # GET /translations.xml
  def index
    @translations = Translation.where("source_id = #{params[:source_id]}")
    @source = Source.find_by_id params[:source_id]
  end

  # GET /translations/1
  # GET /translations/1.xml
  def show
    @translation = Translation.find(params[:id])
    @source = Source.find_by_id params[:source_id]
    ActiveRecord::Base.connection.update("update translations set views = views+1 where id = " + @translation.id.to_s)
    @comments = TransComment.where("translation_id = ?", @translation.id).order("created_at DESC")
  end

  # GET /translations/new
  # GET /translations/new.xml
  def new
    @source = Source.find_by_id params[:source_id]
    if @source.status == 3
      flash[:error] = "此文章已经有最佳翻译了,不能再次重复翻译"
      redirect_to source_path @source
      return
    elsif @source.status == 2
      flash[:error] = "此文章已经有其他人翻译了,如果您对翻译结果不满意可以在这里重新翻译"
      return
    end
    @translation = Translation.where("user_id = #{session[:login_user_id].to_s} and source_id = #{@source.id.to_s}")
    if @translation.size > 0
      flash[:error] = "您已经翻译过此文章了,防止刷分现象,您不能重复翻译"
      redirect_to source_path @source
    end

  end

  # GET /translations/1/edit
  def edit
    @source = Source.find_by_id params[:source_id]
    @translation = Translation.find(params[:id])
    if @translation.user_id == session[:login_user_id] or logged_admin? or logged_xm_admin?
      logger.debug 'edit translations:'+ @translation.id.to_s
    else
      flash.now[:error] = "对不起,您无权进行此操作"
		  render '/errors_messages.html'
    end
  end

  # POST /translations
  # POST /translations.xml
  def create
    @source = Source.find_by_id params[:source_id]
    @translation = Translation.new(params[:translation])
    @translation.source_id = @source.id
    @translation.source_lang_id = @source.source_lang_id
    @translation.source_type_id = @source.source_type_id
    @translation.user_id = session[:login_user_id]
    @translation.dz_user_id = session[:login_user].uid
    @translation.username = session[:login_user].username
    @translation.origin_url = @source.origin_url
    @translation.source_desc = @source.source_desc
    if @translation.save
      flash[:message] = "成功发布翻译"
      credits = 30  # 积分
      ex_credits = 50 # 金币
      if @source.status == 1
        @source.update_attributes({:status => 2})
      elsif
        @source.status == 2
        credits = 5  # 积分
        ex_credits = 10 # 金币
        flash[:message] = "此文章已经有人在你翻译之前发布了翻译,所以您获得积分和金币将比第一个翻译的人要少"
      end
      # 更新发布总数
      user_count = UserCount.where("user_id = #{@translation.user_id.to_s} and app_name = 'tran'").first
      if not user_count
        user_count = UserCount.new
        user_count.user_id = session[:login_user_id]
        user_count.app_name = "tran"
        user_count.uploads = 1
		     user_count.save
      else
        user_count.update_attributes({:uploads => user_count.uploads + 1 })
      end
       # 更新总排行榜
      trans_rank = TranRank.where("user_id = #{@translation.user_id.to_s} and campaign = 'all'").first
      if not trans_rank
        trans_rank = TranRank.new
        trans_rank.user_id = session[:login_user_id]
        trans_rank.campaign = "all"
        trans_rank.total_trans = 1
        trans_rank.total_excredits = ex_credits
        trans_rank.dz_user_id = session[:login_user].uid
        trans_rank.username = session[:login_user].username
		    trans_rank.save
      else
        trans_rank.update_attributes({:total_trans => trans_rank.total_trans + 1 , :total_excredits => trans_rank.total_excredits + ex_credits })
      end
      # 更新第一届翻译大赛排行榜
      trans_rank_f = TranRank.where("user_id = #{@translation.user_id.to_s} and campaign = 'dyjfyds'").first
      if not trans_rank_f
        trans_rank_f = TranRank.new
        trans_rank_f.user_id = session[:login_user_id]
        trans_rank_f.campaign = "dyjfyds"
        trans_rank_f.total_trans = 1
        trans_rank_f.total_excredits = ex_credits
        trans_rank_f.dz_user_id = session[:login_user].uid
        trans_rank_f.username = session[:login_user].username
		    trans_rank_f.save
      else
        trans_rank_f.update_attributes({:total_trans => trans_rank_f.total_trans + 1 , :total_excredits => trans_rank_f.total_excredits + ex_credits })
      end
      # 加金币和积分
      add_discuz_credits @translation.dz_user_id, credits
      add_discuz_extcredits @translation.dz_user_id, ex_credits
      # 发全站动态
      # 发送全局动态
      source_index_url = XMAPP_MAIN_DOMAIN_URL+"/sources"
      trans_url = XMAPP_MAIN_DOMAIN_URL+"/sources/#{@source.id}/translations/#{@translation.id}"
      title_template = "#{@translation.username}在<a href=\"#{source_index_url}\" >译文频道<\/a>翻译了文章<a href=\"#{trans_url}\" >#{@translation.title}<\/a>,并获得了金币,快来投票吧"
	    title_data = {}
	    require 'php_serialization'
	    title_data = PhpSerialization.dump(title_data)
      send_dz_feed 2004, @translation.dz_user_id, @translation.username, title_template, title_data, '', title_data
      # end 发送全局动态
      redirect_to source_path @source
    else
      flash[:error] = "保存错误,请重试"
      redirect_to new_source_translation_path @source
    end
  end

  # PUT /translations/1
  # PUT /translations/1.xml
  def update
    @translation = Translation.find(params[:id])
    @source = Source.find_by_id @translation.source_id
    if params[:update_trans]
      # 编辑更新译文
      if @translation.update_attributes(params[:translation])
        flash[:message] = "成功编辑译文"
        redirect_to my_sources_path
      else
        flash[:error] = "保存错误,请重试"
        redirect_to new_source_path
      end
      return
    end

    # 最佳翻译投票
    if params[:best_tran]
      tp_uid = params[:uid]
       # 查出改用户的总积分
      @dzuser = Dzuser.where("uid = ?", tp_uid).first
      credits = @dzuser.credits
      @translation.update_attributes({:best_trans => @translation.best_trans + 1,  :best_trans_score => @translation.best_trans_score + credits})
      if @translation.best_trans_score >= 6500
         # 查还有没有别的最佳翻译
        other_best = Translation.where("source_id = #{@translation.source_id} and status = 1")
        if other_best.empty?
           # 评为最佳翻译
          @translation.update_attributes({:status => 1})
           # 加金币和积分
          add_discuz_credits @translation.dz_user_id, 20
          add_discuz_extcredits @translation.dz_user_id, @source.excredits
          # 发送全局动态
        source_index_url = XMAPP_MAIN_DOMAIN_URL+"/sources"
        trans_url = XMAPP_MAIN_DOMAIN_URL+"/sources/#{@source.id}/translations/#{@translation.id}"
        title_template = "#{@translation.username}在<a href=\"#{source_index_url}\" >译文频道<\/a>翻译的文章<a href=\"#{trans_url}\" >#{@translation.title}<\/a>被大家评选为最佳翻译,并因此获得了金币#{@source.excredits.to_s}"
	      title_data = {}
	      require 'php_serialization'
	      title_data = PhpSerialization.dump(title_data)
        send_dz_feed 2005, @translation.dz_user_id, @translation.username, title_template, title_data, '', title_data
        # end 发送全局动态
           # 最佳翻译统计
          user_count = UserCount.where("user_id = #{@translation.user_id.to_s} and app_name = 'best_tran'").first
           # 更新发布总数
          if not user_count
            user_count = UserCount.new
            user_count.user_id = @translation.user_id
            user_count.app_name = "best_tran"
            user_count.uploads = 1
		        user_count.save
          else
            user_count.update_attributes({:uploads => user_count.uploads + 1 })
          end
           # 更新排行榜
          trans_rank = TranRank.where("user_id = #{@translation.user_id.to_s} and campaign = 'all'").first
          if trans_rank
            trans_rank.update_attributes({:best_trans => trans_rank.best_trans + 1,
              :total_excredits => trans_rank.total_excredits + @source.excredits })
          end
           # 更新第一届翻译大赛排行榜
          trans_rank_f = TranRank.where("user_id = #{@translation.user_id.to_s} and campaign = 'dyjfyds'").first
          if trans_rank_f
            trans_rank_f.update_attributes({:best_trans => trans_rank_f.best_trans + 1,
              :total_excredits => trans_rank_f.total_excredits + @source.excredits })
          end
           # 更改原文的状态为 不能再翻译了 ,已经有最佳翻译了
          @source.update_attributes({:status => 3,
            :best_trans_id => @translation.id,
            :best_trans_userid => @translation.user_id,
            :best_trans_username =>  @translation.username,
            :best_trans_userdzid => @translation.dz_user_id
            })
        end
      end

       # 防止刷票
      session[:toupiao]["trans_best_"+@translation.source_id.to_s] = 1
      @json_data = {:best_trans => @translation.best_trans}
      render :json => @json_data
      return
    end

    # 顶和踩
    if params[:digg]
      logger.debug "update translation digg"
      @translation.update_attributes({:trans_good => @translation.trans_good + 1})
      @json_data = {:bad => @translation.trans_bad, :good => @translation.trans_good}
      # 防止刷票
      session[:toupiao]["trans_digg_"+@translation.id.to_s] = 1
      # 加金币和积分
      add_discuz_extcredits @translation.dz_user_id, 2
      render :json => @json_data
      return
    elsif params[:bury]
      logger.debug "update translation digg"
      @translation.update_attributes({:trans_bad => @translation.trans_bad + 1})
      @json_data = {:bad => @translation.trans_bad, :good => @translation.trans_good}
      session[:toupiao]["trans_digg_"+@translation.id.to_s] = 1
      add_discuz_extcredits @translation.dz_user_id, -2
      render :json => @json_data
      return
    end


  end
  # 提交评论
  def comments
      logger.debug params[:translation_id]
      trancomment = TransComment.new
      trancomment.translation_id = params[:translation_id]
      trancomment.user_id = session[:login_user_id]
      trancomment.dz_user_id = session[:login_user].uid
      trancomment.username = session[:login_user].username
      trancomment.content = params[:translation_comment]
      if trancomment.save
        flash[:message] = "成功提交评论"
        redirect_to source_translation_path params[:source_id], params[:translation_id]
      else
        flash[:error] = "提交评论失败,可能字数超过限制"
        redirect_to source_translation_path params[:source_id], params[:translation_id]
      end
  end

  # DELETE /translations/1
  # DELETE /translations/1.xml
  def destroy
    @translation = Translation.find(params[:id])
    @translation.destroy

    respond_to do |format|
      format.html { redirect_to(translations_url) }
      format.xml  { head :ok }
    end
  end
end

