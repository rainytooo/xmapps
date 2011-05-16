class Login < ActiveRecord::Base
	validates_presence_of :username
	validates_presence_of :password
end
