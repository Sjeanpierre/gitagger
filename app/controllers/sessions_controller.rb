class SessionsController < ApplicationController
  def new
  end

  def create
		authentication_hash = request.env['omniauth.auth']
		@authorization = Authorization.find_by_provider_and_uid(authentication_hash['provider'], authentication_hash['uid'])
		if @authorization
			session[:user_id] = @authorization.user.id
			#redirect user to repo list once logged in
			flash[:notice] = "Welcome back #{@authorization.user.name}!"
			redirect_to :controller => 'github', :action => 'repo'
		else
			user = User.new(:name => authentication_hash['info']['name'],
											:email => authentication_hash['info']['email'],
											:git_token => authentication_hash['credentials']['token']
											)
			user.authorizations.build :provider => authentication_hash['provider'], :uid => authentication_hash['uid']
			user.save
			session[:user_id] = user.id
			#redirect user to repo list when signup is complete
			flash[:notice] = "Thank you for signing up #{user.name}!"
			redirect_to :controller => 'github', :action => 'repo'
		end
	end

	def destroy
		# is there a better way to destroy sessions?
		session[:user_id] = nil
		render :text => "You've logged out!"
	end

  def failure
		render :text => "Sorry, but you didn't allow access to our app!"
  end
end
