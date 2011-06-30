class TransComment < ActiveRecord::Base
  belongs_to :user,:class_name => "User"
  belongs_to :translation,:class_name => "Translation"
end

