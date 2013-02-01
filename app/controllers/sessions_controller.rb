class SessionsController < ApplicationController
  def new
  end

  def create
		authentication_hash = request.env['omniauth.auth']
		@authorization = Authorization.find_by_provider_and_uid(authentication_hash["provider"], authentication_hash["uid"])
		if @authorization
			session[:user_id] = @authorization.user.id
			render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
		else
			user = User.new(:name => authentication_hash["info"]["name"],
											:email => authentication_hash["info"]["email"],
											:git_token => authentication_hash["credentials"]["token"]
											)
			user.authorizations.build :provider => authentication_hash["provider"], :uid => authentication_hash["uid"]
			user.save
			session[:user_id] = user.id
			render :text => "Hi #{user.name}! You've signed up."
		end
	end

	def destroy
		session[:user_id] = nil
		render :text => "You've logged out!"
	end

  def failure
		render :text => "Sorry, but you didn't allow access to our app!"
  end
end
