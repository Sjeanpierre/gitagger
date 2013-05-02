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
		@repo_name    = params[:repo_name]
		@repo_owner   = params[:repo_owner]
		@branch_name = params[:branch_name]
		@commits = get_commits(git_connection,@repo_name,@repo_owner,@branch_name)
		render :commit
	end

	def commit_detail
		@repo_info = params.to_hash
		@commit = get_commit_details(establish_git_connection,params[:repo_name],params[:repo_owner],params[:commit_sha])
		render :commit_detail
	end

	def tag_detail
		@repo_info = params.to_hash
		@tag_commit = get_commit_details(establish_git_connection,params[:repo_name],params[:repo_owner],params[:commit_sha])
		render :tag_detail
	end

  def tag
		git_connection = establish_git_connection
		@repo_name  = params[:repo_name]
		@repo_owner = params[:repo_owner]
		@branch     = params[:repo_branch]
		@repo_info = params.to_hash
		@tags = get_repo_tags(git_connection,@repo_name,@repo_owner)
		render :tag
  end

	def tagging_page
		@repo_name   = params['repo_name']
		@repo_owner  = params['repo_owner']
		@branch_name = params['branch_name']
		@sha         = params['commit_sha'] || get_commits(establish_git_connection,@repo_name,@repo_owner,@branch_name).first.sha
		render :create_tag
	end

	def create_tag
		@repo_name            = params['repo_name']
		@repo_owner           = params['repo_owner']
		@branch               = params['branch_name']
		@sha                  = params['sha']
		@user                 = User.find(session[:user_id])
		params[:user_name]    = @user.name
		params[:user_email]   = @user.email
		tag_result = tag_repo(establish_git_connection,params)
		if tag_result == true
			flash[:notice] = "Tag #{params[:tag]} created successfully!"
		else
			flash[:notice] = "Could not create tag #{params[:tag]} in #@repo_name"
		end
	end

	def delete_tags
		@tags                 = params['tags']
		@repo_name            = params['repo_name']
		@repo_owner           = params['repo_owner']
		params['tags']        = params['tags'].split(',')
		delete_result = delete_repo_tags(establish_git_connection,params)
		flash[:notice] = "The following tags were deleted successfully #@tags"
		redirect_to :back
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
