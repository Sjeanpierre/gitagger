class GithubController < ApplicationController

	before_filter :check_session, :check_token

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
		repo_name    = params[:repo_name]
		repo_owner   = params[:repo_owner]
		@branch_name = params[:branch_name]
		@commits = get_commits(git_connection,repo_name,repo_owner,@branch_name)
		render :commit
	end

  def tag
		git_connection = establish_git_connection
		@repo_name  = params[:repo_name]
		@repo_owner = params[:repo_owner]
		@branch     = params[:repo_branch]
		@tags = get_repo_tags(git_connection,@repo_name,@repo_owner)
		render :tag
	end


	private
	def establish_git_connection
		user = User.find(session[:user_id])
		Github.new :oauth_token => user.git_token
	end

	def check_session
		redirect_to '/auth/github' unless User.valid_session?(session)
	end

	def check_token
		unless valid_git_token?(establish_git_connection)
		  User.handle_revoked_token(session)
		  redirect_to '/auth/github'
		end
	end

end
