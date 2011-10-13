# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
XiaomaCom::Application.initialize!

ActiveRecord::ConnectionAdapters::MysqlAdapter.emulate_booleans = false
WillPaginate::ViewHelpers.pagination_options[:renderer] = 'PaginationListLinkRenderer'
