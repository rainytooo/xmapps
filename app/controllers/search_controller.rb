class SearchController < ApplicationController
	# 搜索
	def search
		# 预处理
		search_type = params[:type]
		@search_string = params[:query]
		logger.debug @search_string
		@search_string.strip
		if @search_string
			# 去掉多余的空格
			@search_string.squeeze!("\s")
			@origin_words = params[:query].strip
			@origin_words.squeeze("\s")
			@search_string = '%'+@search_string+'%'
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
			search_keyword = SearchKeywords.new
			if session[:login_user_id]
				search_keyword.user_id = session[:login_user_id]
			end
			search_keyword.keywords = @origin_words
			search_keyword.appname = 'dl'
			search_keyword.save
			render 'dl_search.html'
			return
		end

	end
	def sockettest
	  logger.debug 'start a tcp socket ,and send a message'
	  socket_client
  end

	private

		def dl_search

		end

		def socket_client
		  require 'socket'                # Get sockets from stdlib
      streamSock = TCPSocket.new( "127.0.0.1", 12260 )
      test_a = "{\'querytype\' : \'type_value\', \'keywords\' : \'keywords_value\'}"
      logger.debug test_a
      streamSock.send( "#{test_a}\n" , 0)
      content = ""
      loop {
        str = streamSock.recv( 1024 )
        content += str
        if str.length <= 1024
          # check if it has the end flag => '{79end07}'
          len = str.length
          end_flag = str[(len-9)..len]
          logger.debug end_flag
          if end_flag == '{79end07}'
            logger.debug 'the session is over close the scoket connection'
            break
          end
        end
       }
      logger.debug content
      #logger.debug str.bytes.to_a.size
      #logger.debug content.length
      streamSock.close
    end
end

