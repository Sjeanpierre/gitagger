class User < ActiveRecord::Base
  attr_accessible :email, :name, :git_token
	has_many :authorizations
	validates :name, :email, :git_token, :presence => true
end
