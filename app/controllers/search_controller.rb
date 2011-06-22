class SearchController < ApplicationController
	# 搜索
	def search
		# 预处理
		@search_type = params[:type]
		@search_string = params[:query]
		logger.debug @search_string
		@search_string.strip
		if @search_string
		  # 去掉多余的空格
		  @search_string.squeeze!("\s")
		  @origin_words = params[:query].strip
		  @origin_words.squeeze("\s")
		  @search_string = '%'+@search_string+'%'
		  if @search_type == "dl"
        dl_search
      elsif @search_type == "ask"
        ask_search
    elsif @search_type == "all"
        all_search
	    end
		end

	end



	private

	  def search_dl

	  end
	  # 记录用户的搜索
	  def save_user_keyword(type_str)
	    search_keyword = SearchKeywords.new
		  if session[:login_user_id]
			  search_keyword.user_id = session[:login_user_id]
		  end
		  search_keyword.keywords = @origin_words
		  search_keyword.appname = type_str
		  search_keyword.save
   end

	  # 问答的搜索
	  def ask_search
      @asks = Ask.where("title like :search_string or content like :search_string",
          {:search_string => @search_string}).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
      if @asks.empty?
        flash.now[:message] = "对不起,没有搜索到相关内容,您可以在右侧点击我要提问来提出这个问题"
			   render 'ask_search.html'
			   return
      end
      save_user_keyword 'ask'
		  render 'ask_search.html'
		  return
    end
    # 简单的搜索下载
		def dl_search
		  @dl_threads = DlThread.where(" ispass = 1 and  ( name like :search_string  or   ispass = 1 and content_desc like :search_string )",
		      {:search_string => @search_string}).order("created_at DESC").paginate(:page=>params[:page]||1,:per_page=>10)
		  if @dl_threads.empty?
			  flash.now[:message] = "对不起,没有搜索到相关内容,您可以在右侧点击我要上传来添加这个资源,可以获取大量积分和金币"
			  render 'dl_search.html'
			  return
		  end
		  # 拿出最多上传的用户
		  #@rank_users = User.find_by_sql('select * from users LEFT OUTER JOIN user_counts ON user_counts.user_id = users.id where user_counts.uploads != 0 order by user_counts.uploads desc limit 0, 12')
		  # 拿出最热下载
		  #@hot_dl_threads = DlThread.where("ispass = ?", 1).order("views DESC").limit(10).offset(0)
		  # 记录用户搜索的记录
		  save_user_keyword 'dl'
		  render 'dl_search.html'
		  return
		end

		def all_search
	    logger.debug 'start a tcp socket ,and send a message'
	    @html_str = socket_client
	    render 'sockettest.html'
    end

		def socket_client
		  require 'socket'                # Get sockets from stdlib
		  @pagenum = params[:page]
      streamSock = TCPSocket.new( SEARCH_HOST, 12260 )
      test_a = "{\'querytype\' : \'#{@search_type}\', \'keywords\' : \'#{@origin_words}\', \'page\' : \'#{@pagenum}\'}"
      streamSock.send( "#{test_a}\n" , 0)
      content = ""
      repeat_num = 0
      while ( str = streamSock.recv( 1024 ) )
        #logger.debug 'aaaaaaaaaaaaaaaaa' + str
        content += str
        repeat_num += 1
        if repeat_num > 20
          streamSock.close
          break
        end
      end
      logger.debug 'repeat time' + repeat_num.to_s
      #logger.debug str.bytes.to_a.size
      #logger.debug content.length

      return content
    end
end

