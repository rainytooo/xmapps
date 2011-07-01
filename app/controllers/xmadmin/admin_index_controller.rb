class Xmadmin::AdminIndexController < ApplicationController
  before_filter :require_xm_admin ,:only => [:index]
  before_filter :require_zhongjiao_admin ,:only => [:zjfw, :zjfw_baoming]

  def index
  end
  def zjfw
  end
  def zjfw_baoming
    @baomings = Baoming.order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
  end
end

