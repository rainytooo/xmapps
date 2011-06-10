class ViewapiController < ApplicationController
  # 所有新问题
  def asks_new
    # 查询最新的问题
    @new_asks = Ask.find_by_sql("SELECT  * FROM asks ORDER by created_at desc limit 10 OFFSET 0 ")
    # 写出文本
    js_text = "document.write('<div class=\"module cl xl xl1\">\n<ul>"
    @new_asks.each do |ask|
      js_text += "<li>"
      js_text += "<a title=\"#{ask.title}\" href=\"#{XMAPP_MAIN_DOMAIN_URL}/asks/#{ask.id}\">#{ask.title}"
      js_text += "</a></li>"
    end
    js_text += "</ul>\n</div>');"
    render :text => js_text
  end

  # 所有新解决的问题
  def asks_closed
    # 查询最新解决的问题
    @closed_asks = Ask.find_by_sql("SELECT  * FROM asks where status = 1 or status = 2 ORDER by created_at desc limit 10 OFFSET 0 ")
    # 写出文本
    js_text = "document.write('<div class=\"module cl xl xl1\">\n<ul>"
    @closed_asks.each do |ask|
      js_text += "<li>"
      js_text += "<a title=\"#{ask.title}\" href=\"#{XMAPP_MAIN_DOMAIN_URL}/asks/#{ask.id}\">#{ask.title}"
      js_text += "</a></li>"
    end
    js_text += "</ul>\n</div>');"
    render :text => js_text
  end


end

