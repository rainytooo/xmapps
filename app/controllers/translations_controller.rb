class TranslationsController < ApplicationController
  before_filter :require_login , :except => [:index, :show]
  # GET /translations
  # GET /translations.xml
  def index
    @translations = Translation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @translations }
    end
  end

  # GET /translations/1
  # GET /translations/1.xml
  def show
    @translation = Translation.find(params[:id])
    @source = Source.find_by_id params[:source_id]
    ActiveRecord::Base.connection.update("update translations set views = views+1 where id = " + @translation.id.to_s)
  end

  # GET /translations/new
  # GET /translations/new.xml
  def new
    @source = Source.find_by_id params[:source_id]
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
    if @translation.user_id == session[:login_user_id] or logged_admin?
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
      if @source.status != 2
        @source.update_attributes({:status => 2})
      end
      user_count = UserCount.where("user_id = #{session[:login_user_id].to_s} and app_name = 'tran'").first
       # 更新发布总数
      if not user_count
        user_count = UserCount.new
        user_count.user_id = session[:login_user_id]
        user_count.app_name = "tran"
        user_count.uploads = 1
		     user_count.save
      else
        user_count.update_attributes({:uploads => user_count.uploads + 1 })
      end
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
      if @translation.best_trans_score >= 300
         # 查还有没有别的最佳翻译
        other_best = Translation.where("source_id = #{@translation.source_id} and status = 1")
        if other_best.empty?
           # 评为最佳翻译
          @translation.update_attributes({:status => 1})
           # 加金币和积分
          add_discuz_credits @translation.dz_user_id, 100
          add_discuz_extcredits @translation.dz_user_id, 150
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

