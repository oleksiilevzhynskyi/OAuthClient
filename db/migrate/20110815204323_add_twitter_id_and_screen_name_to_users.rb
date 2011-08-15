class AddTwitterIdAndScreenNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_id, :integer, :null => false
    add_column :users, :screen_name, :string
  end
end

