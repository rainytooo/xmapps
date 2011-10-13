class Dzxdb < ActiveRecord::Base
  establish_connection :discuzx
  self.abstract_class = true
end
