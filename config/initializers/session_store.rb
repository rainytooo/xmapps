# Be sure to restart your server when you modify this file.

Xmapps::Application.config.session_store :cookie_store, :key => '_xmapps_session_2'
#require 'action_dispatch/middleware/session/dalli_store'
#Xmapps::Application.config.session_store :dalli_store, :memcache_server => ['192.168.1.161'], :namespace => 'xmapps_sessions', :key => '_xmapps_session' , :domain => :all, :expire_after => 1.day

#Xmapps::Application.config.session_store :cookie_store, :key => '_xmapps_session', :domain => '.testxmcmx.com'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Xmapps::Application.config.session_store :active_record_store
