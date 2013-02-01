module GitHubHelper
	def get_repos(git_connection)
		accessible_repos = {}
		member_organizations = get_organizations(git_connection)
		if member_organizations.count > 0
			org_names = []
			member_organizations.each { |org| org_names << org.login }
			org_names.each do |org|
				org_repos = []
				user_org_teams = get_org_teams(git_connection,org)
				user_org_teams.each do |team|
					team_repos = git_connection.orgs.teams.list_repos team.id
					team_repos.each { |repo| org_repos.push(repo) }
				end
				accessible_repos[org] = org_repos
			end
		end
		user_repos = git_connection.repos.list :type => 'all'
		accessible_repos["own"] = user_repos
		return accessible_repos
	end

	def get_organizations(git_connection)
		git_connection.orgs.list
	end

	def get_org_teams(git_connection,org)
		#it looks like the api only returns teams that the user is part of, including only pull access
		org_teams = git_connection.orgs.teams.list(org)
		org_teams.delete_if { |team| team.permission == "pull" }
		org_teams
	end
end
