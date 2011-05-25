class TagsController < ApplicationController

  # GET /tags/1
  # GET /tags/1.xml
  def show
	# 查出标签
    @tag = Tag.find_by_name(params[:id])
	@tag_name = params[:id]
	if @tag
	# 查出标签下的所有的资源
		@dl_threads = DlThread.find_by_sql("select dl_threads.* from dl_threads right join ( select distinct(object_id) from tag_relationships  where tag_id = #{@tag.id} and taxonomy = 'downloads_tag' ) b on dl_threads.id = b.object_id order by created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
		if @dl_threads.empty?
			flash[:message] = "对不起,没有此标签的相关下载"
		end
	else
		flash[:message] = "对不起,还没有相关内容"
	end
	
  end

end



