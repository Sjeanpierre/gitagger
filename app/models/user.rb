class User < ActiveRecord::Base
  attr_accessible :email, :name, :git_token
	has_many :authorizations
	validates :name, :email, :git_token, :presence => true

  attr_encrypted :git_token, :key => :encryption_key, :attribute => 'git_token_encrypted', :encode => true

  def encryption_key
	  salt = ENV['TOKEN_SALT'].each_char.to_a
		email = self.email.each_char.to_a
		salt.zip(email).flatten.join
  end

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
