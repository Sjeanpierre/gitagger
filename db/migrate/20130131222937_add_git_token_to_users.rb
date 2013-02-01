class AddGitTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :git_token, :string
  end
end
