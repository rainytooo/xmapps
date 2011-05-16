Xmapps::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.serve_static_assets = true
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  # ���²�������Ŀ�õ��ĳ���
  DOWNLOAD_THREAD_PHOTO_ROOT_PATH = "d:/dev/servers/xampp/htdocs/xmappimages"
  DOWNLOAD_THREAD_PHOTO_ROOT_URL = "http://localhost/xmappimages"
  # discuz ��auth key������
  DZ_AUTH_KEY = 'f00c28N7uXnFtcbB'
  # discuz��cookie������
  DZ_COOKIE_PRE = '2vNK_'
  DZ_COOKIE_PATH = '/'
  DZ_COOKIE_DOMAIN = ''
  DZ_COOKIE_NAME = DZ_COOKIE_PRE + Digest::MD5.hexdigest(DZ_COOKIE_PATH + "|" + DZ_COOKIE_DOMAIN)[0,4] + "_auth"
end

