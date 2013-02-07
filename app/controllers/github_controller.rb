class GithubController < ApplicationController

	include GitHubHelper

  def branch
		#TODO need to add more code in the helper to return more details about the branch
		github_connection = establish_git_connection
		@repo_name  = params[:repo_name]
		@repo_owner = params[:repo_owner]
    @branches = get_repo_branches(github_connection,@repo_name,@repo_owner)
		render :branch
  end

  def repo
		github_connection = establish_git_connection
		@repos = get_repos(github_connection)
		render :repo
	end

	def commit
	  git_connection = establish_git_connection
		repo_name   = params[:repo_name]
		repo_owner  = params[:repo_owner]
		@branch_name = params[:branch_name]
		@commits = get_commits(git_connection,repo_name,repo_owner,@branch_name)
		render :commit
	end

  def tag
	end


	private
	def establish_git_connection
		user = User.find(session[:user_id])
		Github.new :oauth_token => user.git_token
	end
end
