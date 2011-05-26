class HomeController < ApplicationController
  def index
	require 'iconv'
	origin_filename = '按时打算'
	request.env['HTTP_USER_AGENT'].match('MSIE')  ? Iconv.conv("utf8", "gb2312", origin_filename) : origin_filename
	logger.info origin_filename
  end
  # 页面无法找到
  def notfound
  end
  # 内部错误
  def errorpage
  end
end
