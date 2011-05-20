class TagsController < ApplicationController

  # GET /tags/1
  # GET /tags/1.xml
  def show
	# 查出标签
    @tag = Tag.find_by_name(params[:id])
	# 查出标签下的所有的资源
	@dl_threads = DlThread.find_by_sql("select dl_threads.* from dl_threads right join ( select distinct(object_id) from tag_relationships  where tag_id = #{@tag.id} and taxonomy = 'downloads_tag' ) b on dl_threads.id = b.object_id order by created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
	
  end

end
