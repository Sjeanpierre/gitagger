class User < ActiveRecord::Base
  attr_accessible :email, :name, :git_token
	has_many :authorizations
	validates :name, :email, :git_token, :presence => true

	def get_current_user
		@user = User.find(session[:user_id])
	end

	def self.valid_session?(session)
		User.exists?(session[:user_id])
	end

	def self.handle_revoked_token(session)
		user = User.find(session[:user_id])
		user.authorizations.destroy_all
	end

end
