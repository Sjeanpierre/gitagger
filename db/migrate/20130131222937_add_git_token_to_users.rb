class AddGitTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :git_token_encrypted, :string
  end
end
