module GitHubHelper
	def get_repos(git_connection)
		accessible_repos = []
		member_organizations = get_organizations(git_connection)
		if member_organizations.count > 0
			org_names = []
			member_organizations.each { |org| org_names << org.login }
			org_names.each do |org|
				user_org_teams = get_org_teams(git_connection,org)
				user_org_teams.each do |team|
					team_repos = git_connection.orgs.teams.list_repos team.id
					team_repos.each { |repo| accessible_repos.push(repo) }
				end
			end
		end
		user_repos = git_connection.repos.list :type => 'all'
		user_repos.each {|repo| accessible_repos.push(repo) }
		accessible_repos.uniq!
		accessible_repos
	end

	def get_organizations(git_connection)
		git_connection.orgs.list
	end

	def get_org_teams(git_connection,org)
		# it looks like the api only returns teams that the user is part of, including only pull access
		org_teams = git_connection.orgs.teams.list(org)
		#TODO verify that this permission rejection is setup properly
		org_teams.delete_if { |team| team.permission == "pull" }
		org_teams
	end

	def get_repo_branches(git_connection,repo_name,repo_owner)
		#TODO this method uses the username of the user which has the ability to change. handle edge cases
		repo_branches = git_connection.repos.branches(repo_owner,repo_name)
		repo_branches
	end

	def get_branch_commits(git_connection,repo_name,repo_owner,branch_name)
		git_connection.get_request("/repos/#{repo_owner}/#{repo_name}/commits", { :sha =>"#{branch_name}"})
	end
end
