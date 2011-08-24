class User < ActiveRecord::Base
  devise :database_authenticatable, :omniauthable

  attr_accessible :name, :email, :login, :password, :password_confirmation, :twitter_id, :screen_name

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_twitter_id(data["id"])
      user
    else # Create a user with a stub password.
      user = User.create(:password => Devise.friendly_token[0,20], :name => data["name"], :twitter_id => data["id"].to_i, :screen_name => data["screen_name"])
      user.save
      user
    end
  end

  def self.find_for_myprovider_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_twitter_id(data["id"])
      user
    else # Create a user with a stub password.
      user = User.create(:password => Devise.friendly_token[0,20], :name => data["name"], :twitter_id => data["id"].to_i, :screen_name => data["screen_name"])
      user.save
      user
    end
  end

end

