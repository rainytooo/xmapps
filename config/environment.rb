# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Xmapps::Application.initialize!

WillPaginate::ViewHelpers.pagination_options[:renderer] = 'PaginationListLinkRenderer'
ActiveRecord::ConnectionAdapters::MysqlAdapter.emulate_booleans = false
# if defined?(PhusionPassenger)
  # PhusionPassenger.on_event(:starting_worker_process) do |forked|
    #Only works with DalliStore
    # Rails.cache.reset if forked
  # end
# end

