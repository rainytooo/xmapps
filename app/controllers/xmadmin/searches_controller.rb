class Xmadmin::SearchesController < ApplicationController
  # 显示现在所有的专题
  def index
    @zhaunti_indexs = ZhuantiIndex.where("index_id = 1").order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>20)
  end

  def show

  end

  def new

  end

  def create
    @zhaunti_index = ZhuantiIndex.new
    @zhaunti_index.title = params[:zhuanti_title]
    @zhaunti_index.url = params[:zhuanti_url]
    @zhaunti_index.content = params[:zhuanti_content]
    @zhaunti_index.content_desc = params[:zhuanti_desc]
    @zhaunti_index.campaign = params[:zhuanti_campaign]
    @zhaunti_index.save
    redirect_to :action => "index"
  end

  def update
    @zhuanti_index = ZhuantiIndex.find(params[:id])
    logger.debug @zhuanti_index.id
    @zhuanti_index.update_attributes({ :index_id => 0 })
    flash[:message] = "成功删除"
    redirect_to :action => "index"
  end

  def refresh
    require 'socket'                # Get sockets from stdlib
		  @pagenum = params[:page]
      streamSock = TCPSocket.new( SEARCH_HOST, 12260 )
      test_a = "{\'querytype\' : \'refreshall\', \'keywords\' : \'#{@origin_words}\', \'page\' : \'#{@pagenum}\'}"
      streamSock.send( "#{test_a}\n" , 0)
      content = ""
      repeat_num = 0
      while ( str = streamSock.recv( 1024 ) )
        content += str
        repeat_num += 1
        if repeat_num > 1
          streamSock.close
          break
        end
      end

  end
end

