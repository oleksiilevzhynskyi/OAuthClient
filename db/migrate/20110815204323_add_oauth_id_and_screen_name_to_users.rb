class AddOauthIdAndScreenNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_id, :integer, :null => false
    add_column :users, :screen_name, :string
  end
end

