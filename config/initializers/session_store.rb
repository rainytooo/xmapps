# Be sure to restart your server when you modify this file.

#XiaomaCom::Application.config.session_store :cookie_store, :key => '_xiaoma.com_session'
require 'action_dispatch/middleware/session/dalli_store'
#XiaomaCom::Application.config.session_store :dalli_store, :memcache_server => ['127.0.0.1'], :namespace => 'xmapps_sessions', :key => '_xmapps_session' , :domain => :all, :expire_after => 1.day
Rails.application.config.session_store :dalli_store, :memcache_server => ['localhost'], :namespace => 'xmapps_sessions', :key => '_xmapps_session', :expire_after => 30.minutes
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# XiaomaCom::Application.config.session_store :active_record_store
