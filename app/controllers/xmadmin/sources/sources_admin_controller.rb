class Xmadmin::Sources::SourcesAdminController < ApplicationController
  before_filter :require_xm_admin, :except => [:del_source, :del_translation]
  # 显示现在所有的专题
  def source
    @sources = Source.order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>30)
  end

  def del_source
    @source = Source.find_by_id params[:id]
    # 翻译
    @translations = Translation.where("source_id = ?" ,@source.id)
    @translations.each do |translation|
      # 扣除翻译积分和金币
      add_discuz_credits translation.dz_user_id, -30
      add_discuz_extcredits translation.dz_user_id, -50
      # 更新发布总数
      user_count = UserCount.where("user_id = #{translation.user_id.to_s} and app_name = 'tran'").first
      if user_count
        user_count.update_attributes({:uploads => user_count.uploads - 1 })
      end
      # 更新排行榜
      trans_rank = TranRank.where("user_id = #{translation.user_id.to_s} and campaign = 'all'").first
      if trans_rank
        trans_rank.update_attributes({:total_trans => trans_rank.total_trans - 1 , :total_excredits => trans_rank.total_excredits - 50 })
      end
      # 更新第一届翻译大赛排行榜
      trans_rank_f = TranRank.where("user_id = #{translation.user_id.to_s} and campaign = 'dyjfyds'").first
      if trans_rank_f
        trans_rank_f.update_attributes({:total_trans => trans_rank_f.total_trans - 1 , :total_excredits => trans_rank_f.total_excredits - 50 })
      end
      if @source.best_trans_id == translation.id
        add_discuz_credits translation.dz_user_id, -20
        add_discuz_extcredits translation.dz_user_id, -@source.excredits
         # 最佳翻译统计
        user_count = UserCount.where("user_id = #{translation.user_id.to_s} and app_name = 'best_tran'").first
         # 更新发布总数
        if user_count
          user_count.update_attributes({:uploads => user_count.uploads - 1 })
        end
          # 更新排行榜
        if trans_rank
          trans_rank.update_attributes({:best_trans => trans_rank.best_trans - 1, :total_excredits => trans_rank.total_excredits - @source.excredits })
        end
        if trans_rank_f
          trans_rank_f.update_attributes({:total_trans => trans_rank_f.total_trans - 1 ,
          :total_excredits => trans_rank_f.total_excredits - @source.excredits })
        end
      end
       # 删除翻译
      translation.destroy
    end
    # 扣除统计
    user_count = UserCount.where("user_id = #{@source.user_id.to_s} and app_name = 'source'").first
     # 更新发布总数
    if user_count
      user_count.update_attributes({:uploads => user_count.uploads - 1 })
    end
    # 扣除积分和金币
    add_discuz_credits @source.dz_user_id, -20
    add_discuz_extcredits @source.dz_user_id, -30
    #删除原文
    @source.destroy
    redirect_to :action => "source"

  end

  def translation
    @translations = Translation.order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>30)

  end

  def del_translation

    translation = Translation.find_by_id params[:id]
    @source = Source.find_by_id translation.source_id
    # 扣除翻译积分和金币
    add_discuz_credits translation.dz_user_id, -30
    add_discuz_extcredits translation.dz_user_id, -50
    # 更新发布总数
    user_count = UserCount.where("user_id = #{translation.user_id.to_s} and app_name = 'tran'").first
    if user_count
      user_count.update_attributes({:uploads => user_count.uploads - 1 })
    end
    # 更新排行榜
    trans_rank = TranRank.where("user_id = #{translation.user_id.to_s} and campaign = 'all'").first
    if trans_rank
      trans_rank.update_attributes({:total_trans => trans_rank.total_trans - 1 , :total_excredits => trans_rank.total_excredits - 50 })
    end
    # 更新第一届翻译大赛排行榜
    trans_rank_f = TranRank.where("user_id = #{translation.user_id.to_s} and campaign = 'dyjfyds'").first
    if trans_rank_f
      trans_rank_f.update_attributes({:total_trans => trans_rank_f.total_trans - 1 , :total_excredits => trans_rank_f.total_excredits - 50 })
    end
    if @source.best_trans_id == translation.id
      add_discuz_credits translation.dz_user_id, -20
      add_discuz_extcredits translation.dz_user_id, -@source.excredits
       # 最佳翻译统计
      user_count = UserCount.where("user_id = #{translation.user_id.to_s} and app_name = 'best_tran'").first
       # 更新发布总数
      if user_count
        user_count.update_attributes({:uploads => user_count.uploads - 1 })
      end
        # 更新排行榜
      if trans_rank
        trans_rank.update_attributes({:best_trans => trans_rank.best_trans - 1, :total_excredits => trans_rank.total_excredits - @source.excredits })
      end
      if trans_rank_f
        trans_rank_f.update_attributes({:total_trans => trans_rank_f.total_trans - 1 ,
        :total_excredits => trans_rank_f.total_excredits - @source.excredits })
      end
    end
     # 删除翻译
    translation.destroy
    redirect_to :action => "translation"
  end

end

