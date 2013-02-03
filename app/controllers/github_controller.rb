class GithubController < ApplicationController

	include GitHubHelper

  def branch
		user = User.find(session[:user_id])
		# We need to add the users git user name to the users table so we can perform the team lookup
		github_connection = Github.new :oauth_token => user.git_token
    @branches = get_repos(github_connection)
		render :text => @branches
		binding.pry
  end

  def repo
		user = User.find(session[:user_id])
		github_connection = Github.new :oauth_token => user.git_token
		@repos = get_repos(github_connection)
		render :repo
  end

  def tag
  end
end
