class SessionsController < ApplicationController
  def new
  end

  def create
		authentication_hash = request.env['omniauth.auth']
		@authorization = Authorization.find_by_provider_and_uid(authentication_hash['provider'], authentication_hash['uid'])
		if @authorization
			session[:user_id] = @authorization.user.id
			flash[:notice] = "Welcome back #{@authorization.user.name}!"
			redirect_to :controller => 'home', :action => 'index'
		else
			user = User.new(:name => authentication_hash['info']['name'],
											:email => authentication_hash['info']['email'],
											:git_token => authentication_hash['credentials']['token']
											)
			user.authorizations.build :provider => authentication_hash['provider'], :uid => authentication_hash['uid']
			user.save
			session[:user_id] = user.id
			flash[:notice] = "Thank you for signing up #{user.name}!"
			redirect_to :controller => 'home', :action => 'index'
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:notice] = "You've been successfully logged out!"
		redirect_to :controller => 'home', :action => 'index'
	end

  def failure
		render :text => "Sorry, but you didn't allow access to our app!"
  end
end
